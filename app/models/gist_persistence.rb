# -*- encoding : utf-8 -*-
class GistPersistence
  include BasicPersistence

  def initialize(flash)
    @flash = flash
  end

  def save_history!(gist_id, user_id)
    GistHistory.create!(
      gist_id: gist_id,
      user_id: user_id
    )
  end

  def save_files!(history, gist_files)
    if gist_files.select { |name, body| body.present? }.empty?
      @flash[:error] = 'Gist file is required.'
      raise 'Gist files are required!'
    end
    # If file name is absent, add default name such as file1,2,3... instead.
    file_count = 1
    gist_files.each do |name, body|
      GistFile.create(
        gist_history_id: history.id,
        name:            name.present? ? name : "file#{file_count}",
        body:            body
      )
      file_count += 1
    end
  end

  def save!(gist, gist_files, current_user)
    transaction do
      if gist.save!
        history = save_history!(gist.id, current_user.try(:id))
        save_files!(history, gist_files)
      end
    end
  end

end

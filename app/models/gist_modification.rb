class GistModification

  def initialize(flash)
    @flash = flash
  end

  def save!(gist, gist_files, current_user)
    ActiveRecord::Base.transaction do
      if gist.save!
        history = GistHistory.create!(
          :gist_id => gist.id,
          :user_id => current_user.try(:id)
        )
        if gist_files.select { |name, body| body.present? }.empty?
          @flash[:error] = 'Gist file is required.'
          raise "Gist files are required!"
        end

        # If file name is absent, add default name such as file1,2,3... instead.
        file_count = 1
        gist_files.each do |name, body|
          GistFile.create(
            :gist_history_id => history.id,
            :name => name.present? ? name : "file#{file_count}",
            :body => body
          )
          file_count += 1
        end
      end
    end
  end

end

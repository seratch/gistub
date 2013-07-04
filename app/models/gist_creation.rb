class GistCreation
  include BasicPersistence
  include GistPersistence

  def initialize(flash)
    @flash = flash
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

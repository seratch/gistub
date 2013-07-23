# -*- encoding : utf-8 -*-
class GistForkCreation
  include BasicPersistence

  def save!(gist_to_fork, current_user)
    transaction do
      created_gist = Gist.create!(
        title:          gist_to_fork.title,
        source_gist_id: gist_to_fork.id,
        user_id:        current_user.try(:id)
      )
      created_history = GistHistory.create!(gist_id: created_gist.id)
      gist_to_fork.latest_history.gist_files.each do |file|
        GistFile.create(
          gist_history_id: created_history.id,
          name:            file.name,
          body:            file.body
        )
      end
      created_gist
    end
  end

end

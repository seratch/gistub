module GistPersistence

  def save_history!(gist_id, user_id)
    GistHistory.create!(
      :gist_id => gist_id,
      :user_id => user_id
    )
  end

  def save_files!(history, gist_files)
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

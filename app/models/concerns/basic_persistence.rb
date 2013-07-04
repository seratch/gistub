module BasicPersistence

  def transaction
    ActiveRecord::Base.transaction do
      yield
    end
  end

end

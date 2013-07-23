# -*- encoding : utf-8 -*-
module BasicPersistence

  def transaction
    ActiveRecord::Base.transaction do
      yield
    end
  end

end

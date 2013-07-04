# -*- encoding : utf-8 -*-
class ChangeGistHistoriesGistIdNotNull < ActiveRecord::Migration
  def up
    change_column :gist_histories, :gist_id, :integer, :null => false
  end

  def down
    change_column :gist_histories, :gist_id, :integer, :null => true
  end
end

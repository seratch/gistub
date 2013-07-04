# -*- encoding : utf-8 -*-
class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :gist_id, :null => false
      t.integer :user_id, :null => false
      t.text :body, :null => false

      t.timestamps
    end
  end
end

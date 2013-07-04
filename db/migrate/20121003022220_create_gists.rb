# -*- encoding : utf-8 -*-
class CreateGists < ActiveRecord::Migration
  def change
    create_table :gists do |t|
      t.string :title, :null => false
      t.boolean :is_public, :null => false
      t.integer :user_id
      t.integer :source_gist_id

      t.timestamps
    end
  end
end

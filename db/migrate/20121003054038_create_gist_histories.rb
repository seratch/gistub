class CreateGistHistories < ActiveRecord::Migration
  def change
    create_table :gist_histories do |t|
      t.integer :gist_id
      t.integer :user_id

      t.timestamps
    end
  end
end

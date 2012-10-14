class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :omniauth_provider, :null => false
      t.string :omniauth_uid, :null => false

      t.timestamps
    end
  end
end

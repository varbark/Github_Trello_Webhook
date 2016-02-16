class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :github_id
      t.string :github_token
      t.string :trello_id
      t.string :trello_token

      t.timestamps null: false
    end
  end
end

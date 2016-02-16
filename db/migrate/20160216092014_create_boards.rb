class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :name
      t.string :trello_id
      t.boolean :syn
      t.references :user, index: true, foreign_key: true
      t.references :repo, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

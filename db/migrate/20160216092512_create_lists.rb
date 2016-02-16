class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :name
      t.string :trello_id
      t.string :category
      t.references :board, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

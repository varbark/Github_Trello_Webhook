class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :name
      t.string :trello_id
      t.references :list, index: true, foreign_key: true
      t.references :issue, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

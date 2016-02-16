class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :name
      t.string :full_name
      t.string :github_id
      t.boolean :syn
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

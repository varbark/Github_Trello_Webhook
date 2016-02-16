# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160216092559) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.string   "name"
    t.string   "trello_id"
    t.boolean  "syn"
    t.integer  "user_id"
    t.integer  "repo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "boards", ["repo_id"], name: "index_boards_on_repo_id", using: :btree
  add_index "boards", ["user_id"], name: "index_boards_on_user_id", using: :btree

  create_table "cards", force: :cascade do |t|
    t.string   "name"
    t.string   "trello_id"
    t.integer  "list_id"
    t.integer  "issue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cards", ["issue_id"], name: "index_cards_on_issue_id", using: :btree
  add_index "cards", ["list_id"], name: "index_cards_on_list_id", using: :btree

  create_table "issues", force: :cascade do |t|
    t.string   "name"
    t.string   "github_id"
    t.integer  "repo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "issues", ["repo_id"], name: "index_issues_on_repo_id", using: :btree

  create_table "lists", force: :cascade do |t|
    t.string   "name"
    t.string   "trello_id"
    t.string   "category"
    t.integer  "board_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "lists", ["board_id"], name: "index_lists_on_board_id", using: :btree

  create_table "repos", force: :cascade do |t|
    t.string   "name"
    t.string   "full_name"
    t.string   "github_id"
    t.boolean  "syn"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "repos", ["user_id"], name: "index_repos_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "github_id"
    t.string   "github_token"
    t.string   "trello_id"
    t.string   "trello_token"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_foreign_key "boards", "repos"
  add_foreign_key "boards", "users"
  add_foreign_key "cards", "issues"
  add_foreign_key "cards", "lists"
  add_foreign_key "issues", "repos"
  add_foreign_key "lists", "boards"
  add_foreign_key "repos", "users"
end

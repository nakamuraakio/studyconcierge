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

ActiveRecord::Schema.define(version: 20150905044604) do

  create_table "comments", force: :cascade do |t|
    t.string   "content",         default: "",    null: false
    t.boolean  "read_flag",       default: false, null: false
    t.integer  "comment_count",   default: 0,     null: false
    t.boolean  "created_by_user", default: true,  null: false
    t.integer  "report_id",       default: 0,     null: false
    t.integer  "user_id",         default: 0,     null: false
    t.integer  "tutor_id",        default: 0,     null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "japanese_percentage",               default: 0,  null: false
    t.string   "japanese_comment",                  default: "", null: false
    t.integer  "old_japanese_percentage",           default: 0,  null: false
    t.string   "old_japanese_comment",              default: "", null: false
    t.integer  "old_chinese_percentage",            default: 0,  null: false
    t.string   "old_chinese_comment",               default: "", null: false
    t.integer  "english_percentage",                default: 0,  null: false
    t.string   "english_comment",                   default: "", null: false
    t.integer  "math_percentage",                   default: 0,  null: false
    t.string   "math_comment",                      default: "", null: false
    t.integer  "physics_percentage",                default: 0,  null: false
    t.string   "physics_comment",                   default: "", null: false
    t.integer  "chemistry_percentage",              default: 0,  null: false
    t.string   "chemistry_comment",                 default: "", null: false
    t.integer  "biology_percentage",                default: 0,  null: false
    t.string   "biology_comment",                   default: "", null: false
    t.integer  "geology_percentage",                default: 0,  null: false
    t.string   "geology_comment",                   default: "", null: false
    t.integer  "world_history_percentage",          default: 0,  null: false
    t.string   "world_history_comment",             default: "", null: false
    t.integer  "japanese_history_percentage",       default: 0,  null: false
    t.string   "japanese_history_comment",          default: "", null: false
    t.integer  "politics_and_economics_percentage", default: 0,  null: false
    t.string   "politics_and_economics_comment",    default: "", null: false
    t.integer  "modern_society_percentage",         default: 0,  null: false
    t.string   "modern_society_comment",            default: "", null: false
    t.integer  "ethics_percentage",                 default: 0,  null: false
    t.string   "ethics_comment",                    default: "", null: false
    t.integer  "geography_percentage",              default: 0,  null: false
    t.string   "geography_comment",                 default: "", null: false
    t.integer  "average_studytime",                 default: 0,  null: false
    t.string   "free_comment",                      default: "", null: false
    t.integer  "user_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.boolean  "japanese",               default: false, null: false
    t.boolean  "old_japanese",           default: false, null: false
    t.boolean  "old_chinese",            default: false, null: false
    t.boolean  "english",                default: false, null: false
    t.boolean  "math",                   default: false, null: false
    t.boolean  "physics",                default: false, null: false
    t.boolean  "chemistry",              default: false, null: false
    t.boolean  "biology",                default: false, null: false
    t.boolean  "geology",                default: false, null: false
    t.boolean  "world_history",          default: false, null: false
    t.boolean  "japanese_history",       default: false, null: false
    t.boolean  "politics_and_economics", default: false, null: false
    t.boolean  "modern_society",         default: false, null: false
    t.boolean  "ethics",                 default: false, null: false
    t.boolean  "geography",              default: false, null: false
    t.integer  "user_id",                default: 0,     null: false
    t.integer  "tutor_id",               default: 0,     null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "tutors", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   default: "",    null: false
    t.binary   "photo",                  default: "x''", null: false
    t.date     "birth",                                  null: false
    t.string   "university",             default: "",    null: false
    t.string   "is_from",                default: "",    null: false
    t.string   "highschool",             default: "",    null: false
    t.string   "nowadays",               default: "",    null: false
    t.string   "dream",                  default: "",    null: false
    t.string   "intro",                  default: "",    null: false
    t.string   "available_day",          default: "",    null: false
    t.integer  "capacity",               default: 5,     null: false
    t.text     "subjects",               default: "",    null: false
  end

  add_index "tutors", ["email"], name: "index_tutors_on_email", unique: true
  add_index "tutors", ["reset_password_token"], name: "index_tutors_on_reset_password_token", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   default: "",    null: false
    t.binary   "photo",                  default: "x''", null: false
    t.date     "birth",                                  null: false
    t.integer  "year",                   default: 3,     null: false
    t.string   "school",                 default: "",    null: false
    t.string   "lives_in",               default: "",    null: false
    t.string   "school_desire",          default: "",    null: false
    t.integer  "report_count",           default: 0,     null: false
    t.integer  "tutor_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end

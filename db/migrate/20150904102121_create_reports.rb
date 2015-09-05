class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.decimal :japanese_percentage, null: false, default: 0
      t.string :japanese_comment, null: false, default: ""
      t.decimal :old_japanese_percentage, null: false, default: 0
      t.string :old_japanese_comment, null: false, default: ""
      t.decimal :old_chinese_percentage, null: false, default: 0
      t.string :old_chinese_comment, null: false, default: ""
      t.decimal :english_percentage, null: false, default: 0
      t.string :english_comment, null: false, default: ""
      t.decimal :math_percentage, null: false, default: 0
      t.string :math_comment, null: false, default: ""
      t.decimal :physics_percentage, null: false, default: 0
      t.string :physics_comment, null: false, default: ""
      t.decimal :chemistry_percentage, null: false, default: 0
      t.string :chemistry_comment, null: false, default: ""
      t.decimal :biology_percentage, null: false, default: 0
      t.string :biology_comment, null: false, default: ""
      t.decimal :geology_percentage, null: false, default: 0
      t.string :geology_comment, null: false, default: ""
      t.decimal :world_history_percentage, null: false, default: 0
      t.string :world_history_comment, null: false, default: ""
      t.decimal :japanese_history_percentage, null: false, default: 0
      t.string :japanese_history_comment, null: false, default: ""
      t.decimal :politics_and_economics_percentage, null: false, default: 0
      t.string :politics_and_economics_comment, null: false, default: ""
      t.decimal :modern_society_percentage, null: false, default: 0
      t.string :modern_society_comment, null: false, default: ""
      t.decimal :ethics_percentage, null: false, default: 0
      t.string :ethics_comment, null: false, default: ""
      t.decimal :geography_percentage, null: false, default: 0
      t.string :geography_comment, null: false, default: ""
      t.decimal :average_studytime, null: false, default: 0
      t.string :free_comment, null: false, default: ""
      t.decimal :user_id

      t.timestamps null: false
    end
  end
end

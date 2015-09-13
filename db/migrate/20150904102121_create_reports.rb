class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :japanese_percentage, null: false, default: 0
      t.string :japanese_comment, null: false, default: ""
      t.integer :old_japanese_percentage, null: false, default: 0
      t.string :old_japanese_comment, null: false, default: ""
      t.integer :old_chinese_percentage, null: false, default: 0
      t.string :old_chinese_comment, null: false, default: ""
      t.integer :english_percentage, null: false, default: 0
      t.string :english_comment, null: false, default: ""
      t.integer :math_percentage, null: false, default: 0
      t.string :math_comment, null: false, default: ""
      t.integer :physics_percentage, null: false, default: 0
      t.string :physics_comment, null: false, default: ""
      t.integer :chemistry_percentage, null: false, default: 0
      t.string :chemistry_comment, null: false, default: ""
      t.integer :biology_percentage, null: false, default: 0
      t.string :biology_comment, null: false, default: ""
      t.integer :geology_percentage, null: false, default: 0
      t.string :geology_comment, null: false, default: ""
      t.integer :world_history_percentage, null: false, default: 0
      t.string :world_history_comment, null: false, default: ""
      t.integer :japanese_history_percentage, null: false, default: 0
      t.string :japanese_history_comment, null: false, default: ""
      t.integer :politics_and_economics_percentage, null: false, default: 0
      t.string :politics_and_economics_comment, null: false, default: ""
      t.integer :modern_society_percentage, null: false, default: 0
      t.string :modern_society_comment, null: false, default: ""
      t.integer :ethics_percentage, null: false, default: 0
      t.string :ethics_comment, null: false, default: ""
      t.integer :geography_percentage, null: false, default: 0
      t.string :geography_comment, null: false, default: ""
      t.integer :average_studytime, null: false, default: 0
      t.string :free_comment, null: false, default: ""
      t.integer :user_id
      t.integer :summary_id

      t.timestamps null: false
    end
  end
end

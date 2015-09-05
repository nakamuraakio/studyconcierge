class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.boolean :japanese, null: false, default: false
      t.boolean :old_japanese, null: false, default: false
      t.boolean :old_chinese, null: false, default: false
      t.boolean :english, null: false, default: false
      t.boolean :math, null: false, default: false
      t.boolean :physics, null: false, default: false
      t.boolean :chemistry, null: false, default: false
      t.boolean :biology, null: false, default: false
      t.boolean :geology, null: false, default: false
      t.boolean :world_history, null: false, default: false
      t.boolean :japanese_history, null: false, default: false
      t.boolean :politics_and_economics, null: false, default: false
      t.boolean :modern_society, null: false, default: false
      t.boolean :ethics, null: false, default: false
      t.boolean :geography, null: false, default: false
      t.integer :user_id, null: false, default: 0
      t.integer :tutor_id, null: false, default: 0

      t.timestamps null: false
    end
  end
end

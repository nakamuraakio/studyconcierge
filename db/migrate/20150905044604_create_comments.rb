class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :content, null: false, default: ""
      t.boolean :read_flag, null: false, default: false
      t.integer :comment_count, null: false, default: 0
      t.boolean :created_by_user, null: false, default: true
      t.integer :summary_id, null: false, default: 0
      t.integer :user_id, null: false, default: 0
      t.integer :tutor_id, null: false, default: 0

      t.timestamps null: false
    end
  end
end

class CreateSummaries < ActiveRecord::Migration
  def change
    create_table :summaries do |t|
      t.integer :user_id
      t.string :name, null: false, default: ""

      t.timestamps null: false
    end
  end
end

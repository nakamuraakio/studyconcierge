class CreateUserEvents < ActiveRecord::Migration
  def change
    create_table :user_events do |t|
      t.string :status, null: false, default: ""
      t.integer :user_id, null: false, default: 0
      t.integer :event_type, null: false, default: 0
      t.string :link, null: false, default: ""

      t.timestamps null: false
    end
  end
end
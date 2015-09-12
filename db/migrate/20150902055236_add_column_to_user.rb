class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :photo, :binary, null: false, default: ""
    add_column :users, :birth, :date, null: false, default: ""
    add_column :users, :year, :integer, null: false, default: "3"
    add_column :users, :school, :string, null: false, default: ""
    add_column :users, :lives_in, :string, null: false, default: ""
    add_column :users, :school_desire, :string, null: false, default: ""
    add_column :users, :report_count, :integer, null: false, default: "0"
    add_column :users, :tutor_id, :integer
    add_column :users, :tutor_request_exists, null: false, default: false
  end
end

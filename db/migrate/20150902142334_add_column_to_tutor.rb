class AddColumnToTutor < ActiveRecord::Migration
  def change
    add_column :tutors, :name, :string, null: false, default: ""
    add_column :tutors, :photo, :binary
    add_column :tutors, :birth, :date, null: false, default: ""
    add_column :tutors, :university, :string, null: false, default: ""
    add_column :tutors, :is_from, :string, null: false, default: ""
    add_column :tutors, :highschool, :string, null: false, default: ""
    add_column :tutors, :nowadays, :string, null: false, default: ""
    add_column :tutors, :dream, :string, null: false, default: ""
    add_column :tutors, :intro, :string, null: false, default: ""
    add_column :tutors, :available_day, :integer, null: false, default: 0
    add_column :tutors, :capacity, :integer, null: false, default: 5
    add_column :tutors, :subjects, :text, null: false, default: ""
  end
end

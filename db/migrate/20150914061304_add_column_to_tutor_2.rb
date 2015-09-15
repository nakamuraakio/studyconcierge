class AddColumnToTutor2 < ActiveRecord::Migration
  def change
    add_column :tutors, :welcome_message, :string
  end
end

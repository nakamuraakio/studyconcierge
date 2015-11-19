class AddStudyingFlagToUsers < ActiveRecord::Migration
  def change
    add_column :users, :studying_flag, :boolean, default: false
    add_column :users, :studying_subject_attribute, :integer, default: 0
    add_column :users, :studying_started_at, :datetime
  end
end

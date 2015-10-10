class AddTutorIdToSummary < ActiveRecord::Migration
  def change
    add_column :summaries, :tutor_id, :integer
  end
end

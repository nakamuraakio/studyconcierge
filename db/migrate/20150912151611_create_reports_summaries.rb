class CreateReportsSummaries < ActiveRecord::Migration
  def change
    create_table :reports_summaries, id: false do |t|
      t.references :report, index: true, foreign_key: true, null: false
      t.references :summary, index: true, foreign_key: true, null: false
    end
  end
end

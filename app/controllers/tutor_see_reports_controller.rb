class TutorSeeReportsController < ApplicationController
  before_action :authenticate_tutor!
  def index
    @users = User.includes(:reports).where(tutor_id: current_tutor.id).references(:posts)
  end

  def show
    @report = Report.find(params[:id])
    if @report.comments.any?
      @comments = Comment.where(report_id: @report.id)
      @comments.each do |comment|
        if !comment.read_flag && comment.created_by_user
          comment.read_flag = true
          comment.save
        end
      end
    end
    @comment = Comment.new
    @comment.report_id = @report.id
  end
end

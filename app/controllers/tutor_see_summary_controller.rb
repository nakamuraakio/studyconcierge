class TutorSeeSummaryController < ApplicationController
  before_action :authenticate_tutor!
  def index
    @users = User.includes(:summaries).where(tutor_id: current_tutor.id)
  end

  def show
    @summary = Summary.find(params[:id])
    @reports = @summary.reports.includes(:user)
    if @summary.comments.any?
      @comments = @summary.comments
      @comments.each do |comment|
        if !comment.read_flag && comment.created_by_user
          comment.update(:read_flag => true)
        end
      end
    end
    @comment = Comment.new
    @comment.summary_id = @summary.id
  end
end

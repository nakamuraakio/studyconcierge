class TutorSeeSummaryController < ApplicationController
  before_action :authenticate_tutor!
  before_action :check_profile

  def index
    @users = User.includes(:summaries).where(tutor_id: current_tutor.id)
  end

  def show
    @summary = Summary.find(params[:id])
    #現在指導中でない学生の報告は読めないようにする
    count = 0
    current_tutor.users.each do |user|
      if @summary.user == user
        break
      else
        count += 1
      end
    end
    if count == current_tutor.users.count || @summary.tutor_id != current_tutor.id #←summaryがcurrent_tutorのものでなかったらアクセスを許可しない
      render_404
    end

    @reports = @summary.reports.includes(:user)
    if @summary.comments.any?
      @comments = @summary.comments.includes(:tutor).includes(:user)
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

class SummariesController < ApplicationController
  #before_action :create
  #before_action do
  #  if !user_signed_in? && !tutor_signed_in?
  #    redirect_to root_path
  #  end
  #end
  before_action :authenticate_user!
  before_action :check_profile


  def index
  	@summaries = Summary.where(user_id: current_user.id).includes(:tutor).includes(:comments)
    if @summaries.count == 0
      flash[:notice] = 'チューターに送信された報告はまだありません'
      redirect_to home_index_path
    end
  end

  def show
  	@summary = Summary.find(params[:id])
  	if @summary.user != current_user
      render_404
    end
  	@comments = @summary.comments.includes(:user).includes(:tutor)
 
  	if @comments.any?
      @comments.each do |comment|
        if !comment.read_flag && !comment.created_by_user
          comment.update(:read_flag => true)
        end
      end
    end
    @comment = Comment.new
    @comment.summary_id = @summary.id
  end
  
  def create
    summary_already_made = Summary.where("created_at >= ? AND user_id = ?", Time.zone.now.beginning_of_day, current_user.id).first
    if current_user.tutor && !current_user.tutor_request_exists && current_user.tutor.available_day == Date.today.wday && summary_already_made.nil?
      #もし前回の報告から7日経過してなければ自動作成しない
      if summary_already_made.nil? || summary_already_made.created_at + 7.days <= Date.today
        @summary = Summary.new(:name => "#{Date.today}作成の記録まとめ", :user_id => current_user.id, :tutor_id => current_user.tutor_id)
        @reports = Report.where('user_id = ? AND created_at >= ? AND created_at < ?', current_user.id, Date.today - 7.days, Date.today).order("created_at DESC")
        @summary.reports << @reports
        @user_event = UserEvent.new(status: '勉強記録のまとめを作成し、報告しました。', user_id: current_user.id, event_type: 7)
        @tutor_event = TutorEvent.new(status: "#{current_user.name}さんが勉強記録を報告しました。", tutor_id: current_user.tutor.id, event_type: 7)
        if @summary.save
          @reports.each do |report| report.save end
          @user_event.link = "/summaries/#{@summary.id}"
          @user_event.save
          @tutor_event.link = "/tutor_see_summary/show/#{@summary.id}"
          @tutor_event.save
          flash.now[:notice] = '今日はあなたのチューターの担当日です。チューターへの報告を作成しました。'
        else
          #render :index
        end           
      else
        flash.now[:notice] = '次回の報告は、前回の報告から１週間を経過後に作成されます。'
      end
    else
      #render :index
    end
  end
  
  
end

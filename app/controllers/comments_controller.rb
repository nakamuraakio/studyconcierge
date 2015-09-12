class CommentsController < ApplicationController
  before_action do
    if !user_signed_in? && !tutor_signed_in?
      redirect_to root_path
    end
  end

  def new
  end

  def create
  	@comment = Comment.new(comment_params)
    @report = Report.find(@comment.report_id)
    @comment.user_id = @report.user.id
    @comment.tutor_id = @report.user.tutor.id
    @comment.comment_count = @report.comments.count + 1
    @user_event = UserEvent.new
    @tutor_event = TutorEvent.new
    if tutor_signed_in?
      @user_event.status = "チューターの#{@report.user.tutor.name}さんからコメントが届いています。"
      @user_event.user_id = @report.user.id
      @user_event.event_type = 2
      @user_event.link = "/reports/#{@report.id}"
      @tutor_event.status = "指導中の#{@report.user.name}さんにコメントを送信しました。"
      @tutor_event.tutor_id = @report.user.tutor.id
      @tutor_event.event_type = 2
      @tutor_event.link = "/tutor_see_reports/show/#{@report.id}"
    elsif user_signed_in?
      @user_event.status = "チューターの#{@reprot.user.tutor.name}さんにコメントを送信しました。"
      @user_event.user_id = current_user.id
      @user_event.event_type = 3
      @user_event.link = "/reports/#{@report.id}"
      @tutor_event.status = "指導中の#{@report.user.name}さんからコメントが届いています。"
      @tutor_event.tutor_id = @report.user.tutor.id
      @tutor_event.event_type = 3
      @tutor_event.link = "/tutor_see_reports/show/#{@report.id}"
    end
    respond_to do |format|
      if @comment.save
        @user_event.save
        @tutor_event.save
      	if user_signed_in?
          format.html { redirect_to @report, notice: 'コメントを作成しました' }
          #format.json { render :show, status: :created, location: @report }
        else
          format.html { redirect_to url_for(:controller => 'tutor_see_reports', :action => 'show', :id => @report.id), notice: 'コメントを作成しました' }
          #format.json { render :show, status: :created, location: @report }
        end
      else
      	if user_signed_in?
          format.html { redirect_to @report }
          format.json { render json: @report.errors, status: :unprocessable_entity }
        else
          format.html { render template: "tutor_see_reports/show" }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  

  def destroy
  	@comment = Comment.find(params[:id])
  	@report = Report.find(@comment.report_id)
    @comment.destroy
    respond_to do |format|
      if user_signed_in?
        format.html { redirect_to @report, notice: 'Comment was successfully destroyed.' }
        format.json { head :no_content }
      else
      	format.html { redirect_to url_for(:controller => 'tutor_see_reports', :action => 'show', :id => @report.id), notice: 'Comment was successfully destroyed.' }
      end
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :report_id, :created_by_user)
    end
end

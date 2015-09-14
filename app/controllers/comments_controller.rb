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
    @summary = Summary.find(@comment.summary_id)
    @comment.user_id = @summary.user.id
    @comment.tutor_id = @summary.user.tutor.id
    @comment.comment_count = @summary.comments.count + 1
    @user_event = UserEvent.new
    @tutor_event = TutorEvent.new
    if tutor_signed_in?
      @user_event.status = "チューターの#{@summary.user.tutor.name}さんからコメントが届いています。"
      @user_event.user_id = @summary.user.id
      @user_event.event_type = 2
      @user_event.link = "/summaries/#{@summary.id}"
      @tutor_event.status = "指導中の#{@summary.user.name}さんにコメントを送信しました。"
      @tutor_event.tutor_id = @summary.user.tutor.id
      @tutor_event.event_type = 2
      @tutor_event.link = "/tutor_see_summary/show/#{@summary.id}"
    elsif user_signed_in?
      @user_event.status = "チューターの#{@summary.user.tutor.name}さんにコメントを送信しました。"
      @user_event.user_id = current_user.id
      @user_event.event_type = 3
      @user_event.link = "/summary/#{@summary.id}"
      @tutor_event.status = "指導中の#{@summary.user.name}さんからコメントが届いています。"
      @tutor_event.tutor_id = @summary.user.tutor.id
      @tutor_event.event_type = 3
      @tutor_event.link = "/tutor_see_summary/show/#{@summary.id}"
    end
    respond_to do |format|
      if @comment.save
        @user_event.save
        @tutor_event.save
      	if user_signed_in?
          format.html { redirect_to @summary, notice: 'コメントを作成しました' }
          #format.json { render :show, status: :created, location: @report }
        else
          format.html { redirect_to url_for(:controller => 'tutor_see_summary', :action => 'show', :id => @summary.id), notice: 'コメントを作成しました' }
          #format.json { render :show, status: :created, location: @report }
        end
      else
      	if user_signed_in?
          format.html { redirect_to @summary}
          format.json { render json: @summary.errors, status: :unprocessable_entity }
        else
          format.html { redirect_to url_for(:controller => 'tutor_see_summary', :action => 'show', :id => @summary.id), notice: 'コメント作成に失敗しました' }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  

  def destroy
  	@comment = Comment.find(params[:id])
  	@summary = Summary.find(@comment.summary_id)
    @comment.destroy
    respond_to do |format|
      if user_signed_in?
        format.html { redirect_to @summary, notice: 'Comment was successfully destroyed.' }
        format.json { head :no_content }
      else
      	format.html { redirect_to url_for(:controller => 'tutor_see_summary', :action => 'show', :id => @summary.id), notice: 'Comment was successfully destroyed.' }
      end
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :summary_id, :created_by_user)
    end
end

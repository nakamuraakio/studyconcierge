class CommentsController < ApplicationController
  before_action :authenticate_user!
  

  def create
  	@comment = Comment.new(comment_params)
    @report = Report.find(@comment.report_id)
    @comment.user_id = @report.user.id
    @comment.tutor_id = @report.user.tutor.id
    @comment.comment_count = @report.comments.count + 1
    if current_tutor
      @comment.created_by_user == false
    end
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @report, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { redirect_to @report }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  

  def destroy
  	@comment = Comment.find(params[:id])
  	@report = Report.find(@comment.report_id)
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @report, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :report_id)
    end
end

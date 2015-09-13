class SummariesController < ApplicationController
  #before_action :create
  before_action do
    if !user_signed_in? && !tutor_signed_in?
      redirect_to root_path
    end
  end

  def index
  	@summaries = Summary.where(user_id: current_user.id)
  end

  def show
  	@summary = Summary.find(params[:id])
  	
  	if @summary.comments.any?
      @summary.comments.each do |comment|
        if !comment.read_flag && !comment.created_by_user
          comment.read_flag = true
          comment.save
        end
      end
    end
    @comment = Comment.new
    @comment.summary_id = @summary.id
  end

  
  
end

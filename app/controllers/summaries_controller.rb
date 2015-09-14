class SummariesController < ApplicationController
  #before_action :create
  #before_action do
  #  if !user_signed_in? && !tutor_signed_in?
  #    redirect_to root_path
  #  end
  #end
  before_action :authenticate_user!

  def index
  	@summaries = Summary.where(user_id: current_user.id)
  end

  def show
  	@summary = Summary.find(params[:id])
  	if @summary.user != current_user
      render '404'
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

  
  
end

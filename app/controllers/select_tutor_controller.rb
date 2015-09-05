class SelectTutorController < ApplicationController
  before_action :authenticate_user!
  def index
    @tutors = Array.new()
  	Tutor.all.each do |tutor|
      if (tutor.users.count < tutor.capacity) && tutor != current_user.tutor
        @tutors.push(tutor)
      end
    end
  	@user = current_user
  	@tutor = @user.tutor || Tutor.new
  end

  def update
  	@user = current_user
  	respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to home_index_path, notice: 'チューターを選択しました' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :index }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def user_params
      params.require(:user).permit(:tutor_id)
    end
end

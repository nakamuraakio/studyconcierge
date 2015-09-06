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

  def show
    @tutor = Tutor.find(params[:id])
    @subjects = Array.new()
    unless @tutor.subject.nil?
      check_subjects(@subjects, @tutor.subject.japanese, '現代文')
      check_subjects(@subjects, @tutor.subject.old_japanese, '古文')
      check_subjects(@subjects, @tutor.subject.old_chinese, '漢文')
      check_subjects(@subjects, @tutor.subject.english, '英語')
      check_subjects(@subjects, @tutor.subject.math, '数学')
      check_subjects(@subjects, @tutor.subject.physics, '物理')
      check_subjects(@subjects, @tutor.subject.chemistry, '化学')
      check_subjects(@subjects, @tutor.subject.biology, '生物')
      check_subjects(@subjects, @tutor.subject.geology, '地学')
      check_subjects(@subjects, @tutor.subject.world_history, '世界史')
      check_subjects(@subjects, @tutor.subject.japanese_history, '日本史')
      check_subjects(@subjects, @tutor.subject.politics_and_economics, '政治経済')
      check_subjects(@subjects, @tutor.subject.modern_society, '現代社会')
      check_subjects(@subjects, @tutor.subject.ethics, '倫理')
      check_subjects(@subjects, @tutor.subject.geography, '地理')
    end
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
  
    def check_subjects(array, element, subject_name)
      if element == true
        return array.push(subject_name)
      end
    end
end

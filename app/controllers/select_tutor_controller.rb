class SelectTutorController < ApplicationController
  before_action :authenticate_user!
  def index
    @tutors = Array.new()
  	Tutor.all.each do |tutor|
      if tutor != current_user.tutor
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
    former_tutor = @user.tutor
    @user_event = UserEvent.new
    @user_event.user_id = @user.id
    @user_event.event_type = 4
    
    if params[:user][:tutor_id] == "0"
      @user.tutor_request_exists = false
    else
      @user.tutor_request_exists = true
    end

  	respond_to do |format|
      if @user.update(user_params)
        if params[:user][:tutor_id] == "0"
          @user_event.status = "チューターを選択解除しました。"
          @user_event.link = "/"
          @user_event.save
          TutorEvent.new(status: "#{@user.name}さんが選択を解除しました。", tutor_id: former_tutor.id, event_type: 4, link: "/tutor_home/user_show/#{@user.id}").save if former_tutor
          format.html { redirect_to home_index_path, notice: 'チューターを選択解除しました' }
        else
          @user_event.status = "チューターに#{@user.tutor.name}さんを選択しました。"
          @user_event.link = "/select_tutor/show/#{@user.tutor.id}"
          @user_event.save
          TutorEvent.new(status: "#{@user.name}さんからチューターに選択されました。", tutor_id: @user.tutor.id, event_type: 4, link: "/tutor_home/user_show/#{@user.id}").save
          TutorEvent.new(status: "#{@user.name}さんが選択を解除しました。", tutor_id: former_tutor.id, event_type: 4, link: "/tutor_home/user_show/#{@user.id}").save if former_tutor
          format.html { redirect_to home_index_path, notice: 'チューターを選択しました。チューターからの承認をお待ち下さい。' }
          format.json { render :show, status: :ok, location: @user }
        end
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

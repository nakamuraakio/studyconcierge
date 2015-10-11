class SelectTutorController < ApplicationController
  before_action :authenticate_user!
  before_action :check, only: :update
  before_action :check_profile

  
  #開発終了時にコメントアウトを解除
  before_action :change_tutor_too_often, only: :update

  def index
    @tutors = Tutor.all.shuffle
#  	Tutor.all.each do |tutor|
#      if tutor != current_user.tutor
#        @tutors.push(tutor)
#      end
#    end
  	@user = current_user
  	@tutor = @user.tutor || Tutor.new
  end

  def show
    @user = current_user
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
          NoticeMailer.designation_notice_to_tutor(@user, @user.tutor).deliver
          TutorEvent.new(status: "#{@user.name}さんがあなたをチューターに選択しようとしています。承認して下さい。", tutor_id: @user.tutor.id, event_type: 4, link: "/tutor_home/user_show/#{@user.id}").save
          TutorEvent.new(status: "#{@user.name}さんが選択を解除しました。", tutor_id: former_tutor.id, event_type: 4, link: "/tutor_home/user_show/#{@user.id}").save if former_tutor
          format.html { redirect_to home_index_path, notice: 'チューターを選択しました。チューターからの承認をお待ち下さい。' }
          format.json { render :show, status: :ok, location: @user }
        end
      else
        format.html { redirect_to select_tutor_index_path, alert: 'エラーが起こりました' }
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

    def change_tutor_too_often
      #もし2週間以内の変更だったならリジェクト
      if current_user.last_tutor_change
        if current_user.last_tutor_change + 1.week > Date.today && Rails.env == 'production'
          flash[:notice] = 'チューターの変更は前回の変更より１週間が経過すると可能になります'
          redirect_to select_tutor_index_path
        end
      end
    end

    def check
      if params[:user].nil?
        flash[:notice] = '更新に失敗しました'
        redirect_to select_tutor_index_path
      end
    end
end

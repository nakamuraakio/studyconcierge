class TutorHomeController < ApplicationController
  before_action :authenticate_tutor!
  before_action :check_profile
  #current_tutorのidと、userテーブルのカラムが一致して初めて見られる

  def index
  	@subjects = {}

    #受験で使った科目の配列を作成
    unless current_tutor.subject.nil?
      create_subject_array(@subjects, current_tutor)
    end
    
    
    
    #未読メッセージの件数を取得
    @comments = Comment.where(tutor_id: current_tutor.id)
    @tutor_events = TutorEvent.where(tutor_id: current_tutor.id).paginate(:page => params[:page], :per_page => 15).order('created_at DESC')

    @unread_messages = 0
    @comments.each do |comment|
      if !comment.read_flag && comment.created_by_user && comment.user.tutor_id == current_tutor.id
        @unread_messages += 1
      end
    end
    
    #未読メッセージの件数を表示
    if @unread_messages != 0
      flash.now[:notice] = "#{@unread_messages} 件の未読メッセージがあります。"
    end
    
    #もし担当日だった場合、指導中の学生の報告が自動的に送られてくる
    @users = current_tutor.users
    @users.each do |user|
      if !user.tutor_request_exists && current_tutor.available_day == Date.today.wday && !Summary.where(name: "#{Date.today}作成の記録まとめ", user_id: user.id).exists?
        flash.now[:info] ||= ["今日はあなたの担当日です。"]
        @summary = Summary.new(:name => "#{Date.today}作成の記録まとめ", :user_id => user.id)
        @reports = Report.where('user_id = ? AND created_at >= ?', user.id, Date.today - 7.days).order("created_at DESC")
        @summary.reports << @reports
        @user_event = UserEvent.new(status: '勉強記録のまとめを作成し、報告しました。', user_id: user.id, event_type: 1)
        @tutor_event = TutorEvent.new(status: "#{user.name}さんが勉強記録を報告しました。", tutor_id: current_tutor.id, event_type: 1)
        flash.now[:info] << "#{user.name}さんが勉強記録を報告しました。"
        if @summary.save
          @reports.each do |report| report.save end
          @user_event.link = "/summaries/#{@summary.id}"
          @user_event.save
          @tutor_event.link = "/tutor_see_summary/show/#{@summary.id}"
          @tutor_event.save
        else
          #render :index
        end           
      else
        #render :index
      end
    end

    #新しく申請してきたユーザーの一覧を取得
    @new_users = User.where(tutor_id: current_tutor.id, tutor_request_exists: true)

    #現時点での今月のお給料の額
    
  end
  
  #「承認する」をクリックした時のアクション
  def user_confirm
    @new_user = User.find(params[:id])
    @new_user.update(:tutor_request_exists => false, :last_tutor_change => Date.today)
    TutorEvent.new(status: "#{@new_user.name}さんを承認しました。", tutor_id: current_tutor.id, event_type: 6, link: "/tutor_home/user_show/#{@new_user.id}").save
    UserEvent.new(status: "#{current_tutor.name}さんがあなたのリクエストを承認しました。", user_id: @new_user.id, event_type: 6, link: "/select_tutor/show/#{current_tutor.id}").save
    redirect_to tutor_home_index_path
  end
  
  #指導中の学生の一覧を取得
  def user_index
    @users = current_tutor.users
  end
  

  def user_show
    #指導中の特定の学生の情報を取得
    @user = User.find(params[:id])

    #もし指導中でなかったらアクセスを拒否
    if @user.tutor != current_tutor
      render_404
    end

    @reports = Report.where(user_id: @user.id)
    @total_studytime = 0
    japanese_studytime = 0
    old_japanese_studytime = 0
    old_chinese_studytime = 0
    english_studytime = 0
    math_studytime = 0
    physics_studytime = 0
    chemistry_studytime = 0
    biology_studytime = 0
    geology_studytime = 0
    world_history_studytime = 0
    japanese_history_studytime = 0
    politics_and_economics_studytime = 0
    modern_society_studytime = 0
    ethics_studytime = 0
    geography_studytime = 0
    @reports.each do |report|
      @total_studytime += report.average_studytime
      japanese_studytime += get_studytime(report, report.japanese_percentage)
      old_japanese_studytime += get_studytime(report, report.old_japanese_percentage)
      old_chinese_studytime += get_studytime(report, report.old_chinese_percentage)
      english_studytime += get_studytime(report, report.english_percentage)
      math_studytime += get_studytime(report, report.math_percentage)
      physics_studytime += get_studytime(report, report.physics_percentage)
      chemistry_studytime += get_studytime(report, report.chemistry_percentage)
      biology_studytime += get_studytime(report, report.biology_percentage)
      geology_studytime += get_studytime(report, report.geology_percentage)
      world_history_studytime += get_studytime(report, report.world_history_percentage)
      japanese_history_studytime += get_studytime(report, report.japanese_history_percentage)
      politics_and_economics_studytime += get_studytime(report, report.politics_and_economics_percentage)
      modern_society_studytime += get_studytime(report, report.modern_society_percentage)
      ethics_studytime += get_studytime(report, report.ethics_percentage)
      geography_studytime += get_studytime(report, report.geography_percentage)
    end
    @subjects = {}

    #勉強時間を自動計算
    check_subjects(@subjects, @user.subject.japanese, '現代文', japanese_studytime)
    check_subjects(@subjects, @user.subject.old_japanese, '古文', old_japanese_studytime)
    check_subjects(@subjects, @user.subject.old_chinese, '漢文', old_chinese_studytime)
    check_subjects(@subjects, @user.subject.english, '英語', english_studytime)
    check_subjects(@subjects, @user.subject.math, '数学', math_studytime)
    check_subjects(@subjects, @user.subject.physics, '物理', physics_studytime)
    check_subjects(@subjects, @user.subject.chemistry, '化学', chemistry_studytime)
    check_subjects(@subjects, @user.subject.biology, '生物', biology_studytime)
    check_subjects(@subjects, @user.subject.geology, '地学', geology_studytime)
    check_subjects(@subjects, @user.subject.world_history, '世界史', world_history_studytime)
    check_subjects(@subjects, @user.subject.japanese_history, '日本史', japanese_history_studytime)
    check_subjects(@subjects, @user.subject.politics_and_economics, '政治経済', politics_and_economics_studytime)
    check_subjects(@subjects, @user.subject.modern_society, '現代社会', modern_society_studytime)
    check_subjects(@subjects, @user.subject.ethics, '倫理', ethics_studytime)
    check_subjects(@subjects, @user.subject.geography, '地理', geography_studytime)
  end

  private
    def check_subjects(array, element, subject_name, studytime)
      if element == true
        return array[subject_name] = (sprintf "%.1f",studytime)
      end
    end
  #
    def create_subject_array(subjects, person)
      check_subjects(subjects, person.subject.japanese, '現代文', 0)
      check_subjects(subjects, person.subject.old_japanese, '古文', 0)
      check_subjects(subjects, person.subject.old_chinese, '漢文', 0)
      check_subjects(subjects, person.subject.english, '英語', 0)
      check_subjects(subjects, person.subject.math, '数学', 0)
      check_subjects(subjects, person.subject.physics, '物理', 0)
      check_subjects(subjects, person.subject.chemistry, '化学', 0)
      check_subjects(subjects, person.subject.biology, '生物', 0)
      check_subjects(subjects, person.subject.geology, '地学', 0)
      check_subjects(subjects, person.subject.world_history, '世界史', 0)
      check_subjects(subjects, person.subject.japanese_history, '日本史', 0)
      check_subjects(subjects, person.subject.politics_and_economics, '政治経済', 0)
      check_subjects(subjects, person.subject.modern_society, '現代社会', 0)
      check_subjects(subjects, person.subject.ethics, '倫理', 0)
      check_subjects(subjects, person.subject.geography, '地理', 0)
    end

    def get_studytime(report, subject_percentage)
      ((report.average_studytime.to_f) * (subject_percentage.to_f) / 100).round(2)
    end
end

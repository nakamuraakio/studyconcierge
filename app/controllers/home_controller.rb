class HomeController < ApplicationController
  before_action :authenticate_user!

  def index

    #各科目の勉強時間の取得
    @reports = Report.where(user_id: current_user)
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

    #科目ごとの「科目　=>　時間」なる連想配列を作成
    unless current_user.subject.nil?
      check_subjects(@subjects, current_user.subject.japanese, '現代文', japanese_studytime)
      check_subjects(@subjects, current_user.subject.old_japanese, '古文', old_japanese_studytime)
      check_subjects(@subjects, current_user.subject.old_chinese, '漢文', old_chinese_studytime)
      check_subjects(@subjects, current_user.subject.english, '英語', english_studytime)
      check_subjects(@subjects, current_user.subject.math, '数学', math_studytime)
      check_subjects(@subjects, current_user.subject.physics, '物理', physics_studytime)
      check_subjects(@subjects, current_user.subject.chemistry, '化学', chemistry_studytime)
      check_subjects(@subjects, current_user.subject.biology, '生物', biology_studytime)
      check_subjects(@subjects, current_user.subject.geology, '地学', geology_studytime)
      check_subjects(@subjects, current_user.subject.world_history, '世界史', world_history_studytime)
      check_subjects(@subjects, current_user.subject.japanese_history, '日本史', japanese_history_studytime)
      check_subjects(@subjects, current_user.subject.politics_and_economics, '政治経済', politics_and_economics_studytime)
      check_subjects(@subjects, current_user.subject.modern_society, '現代社会', modern_society_studytime)
      check_subjects(@subjects, current_user.subject.ethics, '倫理', ethics_studytime)
      check_subjects(@subjects, current_user.subject.geography, '地理', geography_studytime)
    end

    

    #未読メッセージの件数を取得
    @comments = Comment.where(user_id: current_user.id)
    @user_events = UserEvent.where(user_id: current_user.id).paginate(:page => params[:page], :per_page => 10).order('created_at DESC')
    @unread_messages = 0
    @comments.each do |comment|
      if !comment.read_flag && !comment.created_by_user
        @unread_messages += 1
      end
    end
    
    #未読メッセージの件数をflashを用いて表示
    if @unread_messages != 0
      flash.now[:notice] = "#{@unread_messages}件の未読メッセージがあります。"
    end    
    
    #指導中の学生が存在し、もし今日が指導日だったら、学生の報告を自動作成し、両者のタイムラインに表示
    summary_already_made = Summary.where(name: "#{Date.today}作成の記録まとめ", user_id: current_user.id)
    if current_user.tutor && !current_user.tutor_request_exists && current_user.tutor.available_day == Date.today.wday && !summary_already_made.exists?
      #もし前回の報告から7日経過してなければ自動作成しない
      if summary_already_made.last.nil? || summary_already_made.order('created_at').last.created_at + 7.days <= Date.today
        @summary = Summary.new(:name => "#{Date.today}作成の記録まとめ", :user_id => current_user.id)
        @reports = Report.where('user_id = ? AND created_at >= ? AND created_at < ?', current_user.id, Date.today - 7.days, Date.today).order("created_at DESC")
        @summary.reports << @reports
        @user_event = UserEvent.new(status: '勉強記録のまとめを作成し、報告しました。', user_id: current_user.id, event_type: 1)
        @tutor_event = TutorEvent.new(status: "#{current_user.name}さんが勉強記録を報告しました。", tutor_id: current_user.tutor.id, event_type: 1)
        if @summary.save
          @reports.each do |report| report.save end
          @user_event.link = "/summaries/#{@summary.id}"
          @user_event.save
          @tutor_event.link = "/tutor_see_summary/show/#{@summary.id}"
          @tutor_event.save
          flash.now[:notice] = '今日はあなたのチューターの担当日です。チューターへの報告を作成しました。'
        else
          #render :index
        end           
      else
        flash.now[:notice] = '次回の報告は、前回の報告から１週間を経過後に作成されます。'
      end
    else
      #render :index
    end
  end

  private
  #報告する科目について、「科目=>時間」の連想配列を作成
    def check_subjects(array, element, subject_name, studytime)
      if element == true
      	return array[subject_name] = (sprintf "%.1f",studytime)
      end
    end
  #合計勉強時間とその科目の％を渡すと、何時間勉強したかを自動的に計算
    def get_studytime(report, subject_percentage)
      (report.average_studytime.to_f) * (subject_percentage.to_f) / 100
    end

  
end

class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :check_profile

  def index
    @subjects = []
    #各科目の勉強時間の取得
    @reports = Report.where(user_id: current_user)

    @total_studytime = 0

##########　総計の計算 ############
    subject_hash.each do |key, value|
      eval("@#{key}_studytime = 0")
    end

    @reports.each do |report|
      @total_studytime += report.average_studytime
      subject_hash.each do |key, value|
        eval("@#{key}_studytime += report.#{key}_percentage")
      end
    end
    @subjects[0] = {}
    
    #科目ごとの「科目　=>　時間」なる連想配列を作成
    unless current_user.subject.nil?
      subject_hash.each do |key, value|
        eval("check_subjects(@subjects[0], current_user.subject.#{key}, '#{value}', @#{key}_studytime)")
      end
    end
####################################
###########　今日のデータ　###########
    @report_today = Report.where("created_at >= ? AND user_id = ?", Time.zone.now.beginning_of_day, current_user.id).first
    @report_today ||= Report.new

    subject_hash.each do |key, value|
      eval("@#{key}_studytime_of_day = 0")
    end

    subject_hash.each do |key, value|
      eval("@#{key}_studytime_of_day += @report_today.#{key}_percentage")
    end
    @subjects[1] = {}
    
    #科目ごとの「科目　=>　時間」なる連想配列を作成
    unless current_user.subject.nil?
      subject_hash.each do |key, value|
        eval("check_subjects(@subjects[1], current_user.subject.#{key}, '#{value}', @#{key}_studytime_of_day)")
      end
    end

####################################
###########　今週のデータ　###########
    @subjects_this_week = {}
    @total_studytime_of_week = 0
    @reports_this_week = Report.where("created_at >= ? AND user_id = ?", Time.zone.now.beginning_of_week, current_user.id)
    @reports_this_week ||= Report.new

    subject_hash.each do |key, value|
      eval("@#{key}_studytime_of_week = 0")
    end

    @reports_this_week.each do |report|
      @total_studytime_of_week += report.average_studytime
      subject_hash.each do |key, value|
        eval("@#{key}_studytime_of_week += report.#{key}_percentage")
      end
    end
    @subjects[2] = {}
    
    #科目ごとの「科目　=>　時間」なる連想配列を作成
    unless current_user.subject.nil?
      subject_hash.each do |key, value|
        eval("check_subjects(@subjects[2], current_user.subject.#{key}, '#{value}', @#{key}_studytime_of_week)")
      end
    end

####################################
###########　今月のデータ　###########
    @subjects_this_month = {}
    @total_studytime_of_month = 0
    @reports_this_month = Report.where("created_at >= ? AND user_id = ?", Time.zone.now.beginning_of_month, current_user.id)
    @reports_this_month ||= Report.new

    subject_hash.each do |key, value|
      eval("@#{key}_studytime_of_month = 0")
    end

    @reports_this_month.each do |report|
      @total_studytime_of_month += report.average_studytime
      subject_hash.each do |key, value|
        eval("@#{key}_studytime_of_month += report.#{key}_percentage")
      end
    end
    @subjects[3] = {}
    
    #科目ごとの「科目　=>　時間」なる連想配列を作成
    unless current_user.subject.nil?
      subject_hash.each do |key, value|
        eval("check_subjects(@subjects[3], current_user.subject.#{key}, '#{value}', @#{key}_studytime_of_month)")
      end
    end

####################################

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
      #flash.now[:notice] = "#{@unread_messages}件の未読メッセージがあります。"
    end    
    
    #指導中の学生が存在し、もし今日が指導日だったら、学生の報告を自動作成し、両者のタイムラインに表示
    summary_already_made = Summary.where("created_at >= ? AND user_id = ?", Time.zone.now.beginning_of_day, current_user.id).first
    if current_user.tutor && !current_user.tutor_request_exists && current_user.tutor.available_day == Date.today.wday && summary_already_made.nil?
      #もし前回の報告から7日経過してなければ自動作成しない
      if summary_already_made.nil? || summary_already_made.created_at + 7.days <= Date.today
        @summary = Summary.new(:name => "#{Date.today}作成の記録まとめ", :user_id => current_user.id, :tutor_id => current_user.tutor_id)
        @reports = Report.where('user_id = ? AND created_at >= ? AND created_at < ?', current_user.id, Date.today - 7.days, Date.today).order("created_at DESC")
        @summary.reports << @reports
        @user_event = UserEvent.new(status: '勉強記録のまとめを作成し、報告しました。', user_id: current_user.id, event_type: 7)
        @tutor_event = TutorEvent.new(status: "#{current_user.name}さんが勉強記録を報告しました。", tutor_id: current_user.tutor.id, event_type: 7)
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
    #byebug
  end

  def study
    @report = Report.where("created_at >= ? AND user_id = ?", Time.zone.now.beginning_of_day, current_user.id).first
    @report ||= Report.new
    @subject_attribute = params[:subject_attribute]

    @timer_already_moving = false
    
    if current_user.studying_flag == false
      current_user.update(studying_flag: true, studying_subject_attribute: @subject_attribute, studying_started_at: Time.now)
    else
      @timer_already_moving = true
    end

    @h = (Time.now - current_user.studying_started_at).to_i.divmod(3600)
    @m = @h[1].to_i.divmod(60)
    @s = @m[1]

    #byebug

    case @subject_attribute.to_i
    when 1 then
      @text = "現代文"
    when 2 then
      @text = "古文"
    when 3 then
      @text = "漢文"
    when 4 then
      @text = "英語"
    when 5 then
      @text = "数学"
    when 6 then
      @text = "物理"
    when 7 then
      @text = "化学"
    when 8 then
      @text = "生物"
    when 9 then
      @text = "地学"
    when 10 then
      @text = "世界史"
    when 11 then
      @text = "日本史"
    when 12 then
      @text = "地理"
    when 13 then
      @text = "政治経済"
    when 14 then
      @text = "倫理"
    when 15 then
      @text = "現代社会"
    end
  end

  def stop
    current_user.update(studying_flag: false, studying_subject_attribute: 0, studying_started_at: nil)
    redirect_to home_index_path
  end

  

  private
  #報告する科目について、「科目=>時間」の連想配列を作成
    def check_subjects(array, element, subject_name, studytime)
      if element == true
        studytime = studytime.to_f / 60
      	return array[subject_name] = (sprintf "%.1f",studytime)
      end
    end
  #合計勉強時間とその科目の％を渡すと、何時間勉強したかを自動的に計算
    def get_studytime(report, subject_percentage)
      (report.average_studytime.to_f) * (subject_percentage.to_f) / 100
    end

  
end

class TutorHomeController < ApplicationController
  before_action :authenticate_tutor!
  def index
  	@subjects = {}
    unless current_tutor.subject.nil?
      create_subject_array(@subjects, current_tutor)
    end

    if current_tutor.name == "" || current_tutor.birth == "" || current_tutor.university == "" || current_tutor.is_from == "" || current_tutor.highschool == "" || current_tutor.nowadays == "" || current_tutor.dream == "" || current_tutor.available_day == "" || @subjects.empty?
      flash[:notice] = "プロフィールを全て埋めて下さい"
      redirect_to tutors_edit_profile_path
    end

    @comments = Comment.includes(:user).where(tutor_id: current_tutor.id)
    @tutor_events = TutorEvent.where(tutor_id: current_tutor.id)
    @unread_messages = 0
    @comments.each do |comment|
      if !comment.read_flag && comment.created_by_user && comment.user.tutor_id == current_tutor.id
        @unread_messages += 1
      end
    end

    if @unread_messages != 0
      flash.now[:notice] = "#{@unread_messages} 件の未読メッセージがあります。"
    end
  end

  def user_index
    @users = current_tutor.users
  end

  def user_show
    @user = User.find(params[:id])
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
        return array[subject_name] = studytime
      end
    end

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
      (report.average_studytime.to_f) * (subject_percentage.to_f) / 100
    end
end

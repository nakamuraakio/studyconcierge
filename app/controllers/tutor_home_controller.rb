class TutorHomeController < ApplicationController
  before_action :authenticate_tutor!
  def index
  	@subjects = Array.new()
    unless current_tutor.subject.nil?
      check_subjects(@subjects, current_tutor.subject.japanese, '現代文')
      check_subjects(@subjects, current_tutor.subject.old_japanese, '古文')
      check_subjects(@subjects, current_tutor.subject.old_chinese, '漢文')
      check_subjects(@subjects, current_tutor.subject.english, '英語')
      check_subjects(@subjects, current_tutor.subject.math, '数学')
      check_subjects(@subjects, current_tutor.subject.physics, '物理')
      check_subjects(@subjects, current_tutor.subject.chemistry, '化学')
      check_subjects(@subjects, current_tutor.subject.biology, '生物')
      check_subjects(@subjects, current_tutor.subject.geology, '地学')
      check_subjects(@subjects, current_tutor.subject.world_history, '世界史')
      check_subjects(@subjects, current_tutor.subject.japanese_history, '日本史')
      check_subjects(@subjects, current_tutor.subject.politics_and_economics, '政治経済')
      check_subjects(@subjects, current_tutor.subject.modern_society, '現代社会')
      check_subjects(@subjects, current_tutor.subject.ethics, '倫理')
      check_subjects(@subjects, current_tutor.subject.geography, '地理')
    end

    if current_tutor.name == "" || current_tutor.birth == "" || current_tutor.university == "" || current_tutor.is_from == "" || current_tutor.highschool == "" || current_tutor.nowadays == "" || current_tutor.dream == "" || current_tutor.available_day == "" || @subjects.empty?
      flash[:notice] = "プロフィールを全て埋めて下さい"
      redirect_to tutors_edit_profile_path
    end
  end

  def show_user
    @users = current_tutor.users
  end

  private
    def check_subjects(array, element, subject_name)
      if element == true
      	return array.push(subject_name)
      end
    end
end

class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @subjects = Array.new()
    unless current_user.subject.nil?
      check_subjects(@subjects, current_user.subject.japanese, '現代文')
      check_subjects(@subjects, current_user.subject.old_japanese, '古文')
      check_subjects(@subjects, current_user.subject.old_chinese, '漢文')
      check_subjects(@subjects, current_user.subject.english, '英語')
      check_subjects(@subjects, current_user.subject.math, '数学')
      check_subjects(@subjects, current_user.subject.physics, '物理')
      check_subjects(@subjects, current_user.subject.chemistry, '化学')
      check_subjects(@subjects, current_user.subject.biology, '生物')
      check_subjects(@subjects, current_user.subject.geology, '地学')
      check_subjects(@subjects, current_user.subject.world_history, '世界史')
      check_subjects(@subjects, current_user.subject.japanese_history, '日本史')
      check_subjects(@subjects, current_user.subject.politics_and_economics, '政治経済')
      check_subjects(@subjects, current_user.subject.modern_society, '現代社会')
      check_subjects(@subjects, current_user.subject.ethics, '倫理')
      check_subjects(@subjects, current_user.subject.geography, '地理')
    end

    if current_user.name == "" || current_user.birth == "" || current_user.school == "" || current_user.lives_in == "" || current_user.school_desire == "" || @subjects.empty?
      flash[:notice] = "プロフィールを全て埋めて下さい"
      redirect_to users_edit_profile_path
    end
  end

  private
    def check_subjects(array, element, subject_name)
      if element == true
      	return array.push(subject_name)
      end
    end

  
end

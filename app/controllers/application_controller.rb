# encoding: utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  
  def after_sign_in_path_for(resource)
    if current_user
      home_index_path
    elsif current_tutor
      tutor_home_index_path
    else
      '/app_admin'
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  #もしプロフィールに不備があったら訂正を求める
  def check_profile
    if current_user
      if current_user.name == "" || current_user.birth == "" || current_user.school == "" || current_user.lives_in == "" || current_user.school_desire == "" || current_user.subject.nil?
        flash[:notice] = "プロフィールを全て埋めて下さい"
        redirect_to users_edit_profile_path
      end
    elsif current_tutor
      if current_tutor.name == "" || current_tutor.birth == "" || current_tutor.university == "" || current_tutor.is_from == "" || current_tutor.highschool == "" || current_tutor.nowadays == "" || current_tutor.dream == "" || current_tutor.available_day == "" || current_tutor.subject.nil?
        flash[:notice] = "プロフィールを全て埋めて下さい"
        redirect_to tutors_edit_profile_path
      end
    end
  end
  protect_from_forgery with: :exception
end

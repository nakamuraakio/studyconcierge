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

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def subject_hash
    return {
      "japanese" => "現代文",
      "old_japanese" => "古文",
      "old_chinese" => "漢文",
      "english" => "英語",
      "math" => "数学",
      "physics" => "物理",
      "chemistry" => "化学",
      "biology" => "生物",
      "geology" => "地学",
      "world_history" => "世界史",
      "japanese_history" => "日本史",
      "politics_and_economics" => "政治経済",
      "modern_society" => "現代社会",
      "ethics" => "倫理",
      "geography" => "地理",
    }
  end
  
  protect_from_forgery with: :exception
end

class LandingController < ApplicationController
  #http_basic_authenticate_with :name => "akio", :password => "111", only: :index
  layout false
  def index
  	if current_user
  	  redirect_to home_index_path
  	elsif current_tutor
  	  redirect_to tutor_home_index_path
  	end
  end

  def terms
  end

  def specified_commercial_transactions
  end
end
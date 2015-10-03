class Tutors::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]
http_basic_authenticate_with :name => "akio", :password => "111", only: :new

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  def edit_profile
    @tutor = Tutor.find(current_tutor.id)
  end
  # GET /resource/edit
  def update_profile
    @tutor = Tutor.find(current_tutor.id)
    respond_to do |format|
      if @tutor.update(tutor_params)
        TutorEvent.new(status: 'プロフィールを変更しました。', event_type: 5, tutor_id: @tutor.id, link: "/").save
        format.html { redirect_to tutor_home_index_path, notice: 'プロフィールを更新しました' }
        format.json { render :show, status: :ok, location: @tutor }
      else
        format.html { render :edit_profile }
        format.json { render json: @tutor.errors, status: :unprocessable_entity }
      end
    end
  end

  def photo
    @tutor = Tutor.find(params[:id])
    send_data(@tutor.photo, :type => 'image', :disposition => 'inline')
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected
    def tutor_params
      params.require(:tutor).permit(:email, :name, :photo_file, :birth, :university, :is_from, :zipcode, :prefecture, :highschool, :nowadays, :dream, :intro, :available_day, :capacity, :welcome_message, subject_attributes: [:id, :japanese, :old_japanese, :old_chinese, :english, :math, :physics, :chemistry, :biology, :geology, :world_history, :japanese_history, :politics_and_economics, :modern_society, :ethics, :geography])
    end

    def after_update_path_for(resource)
      tutor_home_index_path
    end

    
    
  
  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end

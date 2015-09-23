class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super
  end

  def edit_profile
    @user = User.find(current_user.id)
  end
  # GET /resource/edit
  def update_profile
    @user = User.find(current_user.id)
    
    respond_to do |format|
      if @user.update(user_params)
        UserEvent.new(status: 'プロフィールを変更しました。', event_type: 5, user_id: @user.id, link: "/").save
        format.html { redirect_to home_index_path, notice: 'プロフィールを更新しました' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit_profile }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def photo
    @user = User.find(params[:id])
    send_data(@user.photo, :type => 'image', :disposition => 'inline')
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
  
    def user_params
      params.require(:user).permit(:email, :name, :photo_file, :birth, :year, :school, :lives_in, :school_desire, subject_attributes: [:id, :japanese, :old_japanese, :old_chinese, :english, :math, :physics, :chemistry, :biology, :geology, :world_history, :japanese_history, :politics_and_economics, :modern_society, :ethics, :geography])
    end

    def after_update_path_for(resource)
      home_index_path
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

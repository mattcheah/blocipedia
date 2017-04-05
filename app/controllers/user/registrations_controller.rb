class User::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  
  #GET /user/upgrade
  def upgrade
	@user = current_user
	@stripe_btn_data = {
  		key: "#{Rails.configuration.stripe[:publishable_key]}",
  		description: "Blocipedia Premium Membership - #{@user.email}",
  		amount: Amount.default
  	}
  end
  
  def downgrade
  	@user = current_user

  	if @user.admin?
  		flash[:notice] = "You are an admin and cannot be downgraded!"
		redirect_to edit_user_registration_path
  	elsif @user.standard?
  		flash[:notice] = "You are already a standard user!"
		redirect_to edit_user_registration_path
  	elsif @user.premium?
  	
		@user.standard!
		
		@user_wikis = Wiki.where(user_id: @user.id)
	
		@user_wikis.each do |wiki|
			wiki.private = false
			wiki.save
		end
		
		if @user.role == "standard"
			flash[:notice] = "You have downgraded to a standard account. You will not be charged next month."
			redirect_to edit_user_registration_path
			
		else
			flash.now[:alert] = "Your account was unable to be downgraded, please try again."
			render edit_user_registration_path
		end
	end
	return
	
  end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
   def edit
     #super
     @my_wikis = Wiki.where(user_id: current_user.id)
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

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
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

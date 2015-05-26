class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :auth

  def facebook
    oauth
  end

  def twitter
    oauth
  end

  def confirm_email
    oauth
  end

  private

  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
  end

  def oauth
    @user = User.find_for_oauth(auth)
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      render 'omniauth/confirm_email', locals: {auth: auth}
    end
  end
end
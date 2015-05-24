class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    #@user = User.find_for_oauth(request.env['omniauth.auth'])
    render json: request.env['omniauth.auth']
  end
end
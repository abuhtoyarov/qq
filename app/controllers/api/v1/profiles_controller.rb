class Api::V1::ProfilesController < Api::V1::BaseController
  before_action :current_resource_owner
  before_action :load_users, only: :users


  respond_to :json

  def me
    respond_with @current_resource_owner
  end

  def users
    respond_with @users
  end

  protected

  def load_users
    @users ||= User.where.not(id:@current_resource_owner)
  end

end
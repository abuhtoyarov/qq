class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :current_resource_owner
  before_action :load_users, only: :users
  skip_authorization_check

  respond_to :json

  def me
    respond_with @current_resource_owner
  end

  def users
    respond_with @users
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def load_users
    @users ||= User.where.not(id:@current_resource_owner)
  end

end
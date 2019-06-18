class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions
  before_action :authenticate_request
  attr_reader :current_user

  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message }, status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: {}, status: :not_found
  end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end

class V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request
  skip_authorization_check

  def authenticate
    command = AuthenticateUser.call(signup_params[:email], signup_params[:password])

    if command.success?
      render json: command.result
    else
      render json: {error: command.errors}, status: :unauthorized
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def signup_params
    params.permit(:email, :password)
  end
end

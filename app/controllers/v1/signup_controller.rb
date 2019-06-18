class V1::SignupController < ApplicationController
  skip_before_action :authenticate_request

  # POST /signup
  def signup
    @user = User.new_cook(signup_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def signup_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end

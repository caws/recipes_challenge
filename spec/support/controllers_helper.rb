module ControllerHelpers
  def authenticate_user(email, password)
    command = AuthenticateUser.call(email, password)

    unless command.success?
      return {error: command.errors}
    end

    {Authorization: command.result[:auth_token]}
  end
end
class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    # JsonWebToken.encode(user_id: user.id) if user
    if user
      obj = {
          user: V1::UserSerializer.new(user),
          auth_token: JsonWebToken.encode(user_id: user.id)
      }
    end
  end

  private

  attr_accessor :email, :password

  def user
    user = User.find_by_email(email)
    return user if user && user.authenticate(password)

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end
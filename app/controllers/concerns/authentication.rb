module Authentication
  include Dry::Monads[:try, :maybe]

  def current_user
    @current_user ||= find_current_user.success
  end

  def find_current_user
    @current_user_result ||= Users::FindCurrentUser.call request.headers['authorization']
  end

  def authenticate
    if find_current_user.success?
      @current_user = find_current_user.success
    else
      render json: { errors: find_current_user.failure }, status: :unauthorized
    end
  end
end

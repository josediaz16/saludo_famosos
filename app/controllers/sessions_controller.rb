class SessionsController < ApplicationController
  def create
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      time = (Time.now + 24.hours.to_i).strftime("%m-%d-%Y %H:%M")

      render(
        json: { token: JsonWebToken.encode(user_id: @user.id), exp: time, username: @user.username },
        status: :ok
      )
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end

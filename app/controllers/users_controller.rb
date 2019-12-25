class UsersController < ApplicationController
  skip_before_action :authenticate, only: %i[create]
  # POST /users
  def create
    json_action Users::CreateByRole, user_params
  end

  private

  def user_params
    params.require(:user).permit!.to_h
  end
end

class UsersController < ApplicationController
  # POST /users
  def create
    json_action Users::Create, user_params
  end

  private

  def user_params
    params.require(:user).permit!.to_h
  end
end

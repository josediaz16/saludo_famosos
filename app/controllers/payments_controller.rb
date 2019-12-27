class PaymentsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :create

  def create
    input = params
      .permit!
      .to_hash
      .deep_symbolize_keys

    result = Payments::Create.(input)
    if result.success?
      render json: {}, status: 200
    else
      render json: {}, status: 400
    end
  end
end

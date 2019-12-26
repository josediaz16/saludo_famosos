class MessageRequestsController < ApplicationController
  skip_before_action :authenticate

  def create
    json_action MessageRequests::Create, message_request_params
  end

  private

  def message_request_params
    params
      .permit!
      .to_h
      .symbolize_keys
      .tap do |message_request|
        Dry::Monads.Maybe(current_user)
          .bind { message_request.merge!(fan_id: current_user.fan.id) }
      end
  end
end

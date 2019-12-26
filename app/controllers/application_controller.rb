class ApplicationController < Jets::Controller::Base
  include Authentication

  before_action :authenticate

  rescue_from ActionController::ParameterMissing, with: :handle_missing_params

  def handle_missing_params(exception)
    render(
      json: { errors: Errors::Parser.detect("#{exception.param};base;blank;;#{exception.message}").parse },
      status: 400
    )
  end

  def json_action(service, input)
    result = service.(input)
    if result.success?
      render json: render_serialized_model(result.success), status: :ok
    else
      render json: result.failure.slice(:errors), status: 422
    end
  end

  def render_serialized_model(result)
    SerializerRegistry.render_json(result[:model])
  end

end

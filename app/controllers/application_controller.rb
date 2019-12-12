class ApplicationController < Jets::Controller::Base
  rescue_from ActionController::ParameterMissing, with: :handle_missing_params

  def json_action(service, input)
    result = service.(input)
    if result.success?
      render json: result.success[:model], status: :ok
    else
    pp result.failure
      render json: result.failure.slice(:errors), status: 422
    end
  end

  def handle_missing_params(exception)
    render(
      json: { errors: Errors::Parser.detect("#{exception.param};base;blank;;#{exception.message}").parse },
      status: 400
    )
  end
end

class ApplicationController < ActionController::API
  include ActionController::ImplicitRender
  include ActionController::MimeResponds

  rescue_from ActionController::UnpermittedParameters, with: :general_message
  rescue_from ActionController::RoutingError, with: :route_not_found

  def general_message(exception)
    render json: { message: exception.message }, status: :unprocessable_entity
    true
  end

  def route_not_found
    render json: { message: 'page not found' }, status: :not_found
    true
  end
end

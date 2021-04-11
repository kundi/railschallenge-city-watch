class ApplicationController < ActionController::API
  include ActionController::ImplicitRender
  include ActionController::MimeResponds

  rescue_from ActionController::UnpermittedParameters, with: :general_message
  rescue_from ActionController::RoutingError, with: :route_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_message

  def general_message(exception)
    render json: { message: exception.message }, status: :unprocessable_entity
    true
  end

  def not_found_message(exception)
    if (params[:name] && params[:name] == 'new') || (params[:code] && params[:code] == 'new')
      render json: { message: 'page not found' }, status: :not_found
    else
      render json: { message: exception.message }, status: :not_found
    end
    true
  end

  def route_not_found
    render json: { message: 'page not found' }, status: :not_found
    true
  end
end

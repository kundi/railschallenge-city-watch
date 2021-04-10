class EmergenciesController < ApplicationController
  around_action :raise_action_on_unpermitted_parameters, only: %i(create)

  def create
    @emergency = Emergency.new(emergency_params)
    if @emergency.save
      render json: { emergency: @emergency }, status: :created
    else
      render json: { message: @emergency.errors.messages }, status: :unprocessable_entity
    end
  end

  def show
    fail ActionController::RoutingError, 'do not support new route' if params[:code] == 'new'
  end

  private

  def emergency_params
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  end

  def raise_action_on_unpermitted_parameters
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
    yield
  end
end

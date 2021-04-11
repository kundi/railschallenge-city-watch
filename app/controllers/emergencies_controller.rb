class EmergenciesController < ApplicationController
  around_action :raise_action_on_unpermitted_parameters, only: %i(create)
  before_action :set_default_response_format
  before_action :set_emergency, only: %i(show update)

  def index
    @emergencies = Emergency.all
  end

  def create
    @emergency = Emergency.new(emergency_params_for_create)
    if @emergency.save
      response_hash = @emergency.attributes.merge(responders: @emergency.responders.pluck(:name),
                                                  full_response: Emergency.calculate_full_response_ration)
      render json: { emergency: response_hash }, status: :created
    else
      render json: { message: @emergency.errors.messages }, status: :unprocessable_entity
    end
  end

  def update
    if @emergency.update(emergency_params_for_update)
      render json: { emergency: @emergency }, status: :ok
    else
      render json: { message: @emergency.errors.messages }, status: :unprocessable_entity
    end
  end

  def show
    fail ActionController::RoutingError, 'do not support new route' if params[:code] == 'new'
  end

  private

  def emergency_params_for_create
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  end

  def emergency_params_for_update
    params.require(:emergency).permit(:fire_severity, :police_severity, :medical_severity, :resolved_at)
  end

  def set_default_response_format
    request.format = :json
  end

  def set_emergency
    @emergency = Emergency.find(params[:code])
  end

  def raise_action_on_unpermitted_parameters
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
    yield
  end
end

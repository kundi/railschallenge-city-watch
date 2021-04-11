class RespondersController < ApplicationController
  around_action :raise_action_on_unpermitted_parameters, only: %i(create)
  before_action :set_default_response_format
  before_action :set_responder, only: %i(show update)

  def index
    @responders = Responder.all
    @show_capacity = params[:show]
    @capacities = CapacityCalculator.call(@responders) if @show_capacity && @show_capacity == 'capacity'
  end

  def create
    @responder = Responder.new(responder_params_for_create)
    if @responder.save
      render json: { responder: @responder.attributes }, status: :created
    else
      render json: { message: @responder.errors.messages }, status: :unprocessable_entity
    end
  end

  def update
    if @responder.update(responder_params_for_update)
      render json: { responder: @responder.attributes }, status: :ok
    else
      render json: { message: @responder.errors.messages }, status: :unprocessable_entity
    end
  end

  def show
    fail ActionController::RoutingError, 'do not support new route' if params[:name] == 'new'
  end

  private

  def responder_params_for_create
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def responder_params_for_update
    params.require(:responder).permit(:on_duty)
  end

  def set_default_response_format
    request.format = :json
  end

  def set_responder
    @responder = Responder.find(params[:name])
  end

  def raise_action_on_unpermitted_parameters
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
    yield
  end
end

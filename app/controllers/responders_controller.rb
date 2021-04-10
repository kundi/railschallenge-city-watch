class RespondersController < ApplicationController
  around_action :raise_action_on_unpermitted_parameters, only: %i(create)

  def create
    @responder = Responder.new(responder_params)
    if @responder.save
      render json: { responder: @responder.attributes }, status: :created
    else
      render json: { message: @responder.errors.messages }, status: :unprocessable_entity
    end
  end

  def show
    fail ActionController::RoutingError, 'do not support new route' if params[:name] == 'new'
  end

  private

  def responder_params
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def raise_action_on_unpermitted_parameters
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
    yield
  end
end

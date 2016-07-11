class CabsController < ApplicationController
  before_action :set_cab, only: [:show, :update, :activate, :destroy]
  load_and_authorize_resource

  def index
    @cabs = Cab.all
    render json: @cabs
  end


  def show
    render json: @cab
  end

  def create
    @cab = Cab.new(cab_params)

    if @cab.save
      render json: @cab, status: :created, location: @cab
    else
      render json: @cab.errors, status: :unprocessable_entity
    end
  end


  def update
    if @cab.update(cab_params)
      render json: @cab
    else
      render json: @cab.errors, status: :unprocessable_entity
    end
  end

  def activate
    if @cab.update_current_location(params[:latitude], params[:longitude])
      render json: @cab
    else
      render json: @cab.errors, status: :unprocessable_entity
    end
  end


  def destroy
    @cab.destroy
  end


  private

  def set_cab
    @cab = Cab.find(params[:id])
  end

  def cab_params
    params.require(:cab).permit(:name, :color, :latitude, :longitude)
  end

end

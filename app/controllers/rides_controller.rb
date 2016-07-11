class RidesController < ApplicationController
  load_and_authorize_resource
  before_action :find_active_ride, only: [:cancel, :complete]

  def index
    @rides=Ride.accessible_by(current_ability).all
    render json: @rides
  end

  def create
    @ride=current_user.rides.new(ride_params)
    if @ride.save
      render json: @ride, status: :created, location: @ride
    else
      render json: @ride.errors, status: :unprocessable_entity
    end
  end

  def cancel
    if @ride.cancel
      render json: @ride
    else
      render json: @ride.errors, status: :unprocessable_entity
    end
  end

  def complete
    if @ride.complete
      render json: @ride
    else
      render json: @ride.errors, status: :unprocessable_entity
    end
  end

  private
  def find_active_ride
    @ride=Ride.accessible_by(current_ability).active.find(params[:id])
  end

  def ride_params
    params.require(:ride).permit(:source_latitude, :source_longitude, :destination_latitude, :destination_longitude)
  end

end

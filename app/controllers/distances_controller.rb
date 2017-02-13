class DistancesController < ApplicationController
before_action :logged_in_user, only: [:show, :new, :create, :destroy]

  def new
    @distance = Distance.new
  end

  def show
    @user = current_user
    @distances  = @user.distances
  end

  def create
    #@distance = current_user.distances.build(distance_params)
    #@distance.user_id = @user.distances.build(distance_params)
    @distance = current_user.distances.build(distance_params)
    if @distance.save
      # Handle a successful save.
      flash[:success] = "Beitrag wurde gespeichert"
      redirect_to current_user
    else
      render 'new'
    end
  end

  private

  def distance_params
    params.require(:distance).permit(:zielpunkt, :startpunkt, :verkehrsmittel)
  end
end

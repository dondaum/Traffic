class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @distances  = @user.distances
  end

  def create
      @user = User.new(user_params)
      if @user.save
        log_in @user
        flash[:success] = "Sie haben sich erfolgreich registriert!"
        redirect_to @user # Handle a successful save.
      else
        render 'new'
      end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :name, :email, :password,
                                 :password_confirmation)
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

end

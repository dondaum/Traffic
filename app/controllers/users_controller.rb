class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end


    def create
      @user = User.new(user_params)
      if @user.save
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
end

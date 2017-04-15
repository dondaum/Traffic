class SessionsController < ApplicationController
  def new
  end


  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        redirect_to user
      else
        message  = "Account nicht aktiviert. "
        message += "Bitte rufen Sie Ihre Emails auf um den Link zu klicken."
        flash[:warning] = message
        redirect_to root_url
      end
      else
        flash.now[:danger] = 'Falsche Email Passwort Kombination' # Not quite right!
        render 'new'
      end
    end


#  def create
#    user = User.find_by(email: params[:session][:email].downcase)
#    if user && user.authenticate(params[:session][:password])
#      log_in user
#      redirect_to user
#    else
#      flash.now[:danger] = 'Falsche Email Passwort Kombination' # Not quite right!
#      render 'new'
#    end
#  end

  def destroy
     log_out
     redirect_to root_url
  end
end

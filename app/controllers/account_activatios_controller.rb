class AccountActivatiosController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account erfolgreich aktiviert!"
      redirect_to user
      ModelMailer.new_record_notification(user).deliver
    else
      flash[:danger] = "Falscher Aktivierrungslink"
      redirect_to root_url
    end
  end
end

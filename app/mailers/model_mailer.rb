class ModelMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.model_mailer.new_record_notification.subject
  #
  default from: "me@floating-reef-63299.com"

  def new_record_notification(user)
    @user = user
    mail to: "sebastian.daum89@gmail.com", subject: "Ein neuer User hat sich für die Travel App registriert"
  end
end

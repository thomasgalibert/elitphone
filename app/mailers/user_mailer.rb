class UserMailer < ApplicationMailer
  default from: 'thomas@gmail.com'
  
  def welcome
    mail(to: "nicolas.martin@hotmail.com", subject: 'Welcome to My Awesome Site')
  end
  
end

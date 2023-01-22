class PasswordResetsController < ApplicationController 
  def new 

  end 

  def create 
    @user = User.find_by_email(params[:email]) 
    if @user.present?
      # Send email
      PasswordMailer.with(user: @user).reset.deliver_now
    end 

    redirect_to root_url, notice: "If the account exists, a link was sent to your email." 
  end 
  def edit 
    @user = User.find_signed(params[:token], purpose: "password_reset")
  rescue ActionController::MessageVerifier::InvalidSignature
    redirect_to sign_in_path, alert: "Token expired or invalid"
  end 
  def update 
    @user = User.find_signed(params[:token], purpose: "password_reset")
    if @user.update(password_params)
      redirect_to sign_in_path, notice: "Your password has been changed."
    else
      render :edit, status: :bad_request
    end
  end
  
  private 

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  
end 

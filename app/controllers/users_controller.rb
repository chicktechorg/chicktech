class UsersController < ApplicationController
  # def index
  #   @users = User.all
  # end

  # def new
  #   @user = User.new
  # end

  # def create
  #   @user = User.new(user_params)
  #   if @user.save
  #     flash[:notice] = "User has been created."
  #     redirect_to root_url
  #   else
  #     flash[:alert] = "Something went wrong."
  #     render :new
  #   end
  # end

  # def show
  #   # if !user_signed_in?
  #   #   redirect_to new_user_session_path
  #   # else
  #     @user = User.find(params[:id])
  #   # end
  # end

private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :password, :password_confirmation, :role)
  end
end
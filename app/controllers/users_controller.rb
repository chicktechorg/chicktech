class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    @user = User.new
    authorize! :create, @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "#{@user.first_name} has successfully been created."

      redirect_to users_path
    else
      flash[:alert] = "Something went wrong."
      render :new
    end
  end

  def show
   @user = User.find(params[:id])
   @events = Event.all
   @jobs = Job.all
   redirect_to edit_user_path(@user) if @user.first_name.nil?
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "User has been updated."
      redirect_to users_path
    else
      binding.pry
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Your user has been destroyed"
    redirect_to users_path
  end

private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :password, :password_confirmation, :role)
  end

end
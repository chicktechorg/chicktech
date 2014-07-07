class UsersController < ApplicationController
  authorize_resource

  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.xls {send_data @users.to_xls(:columns => [:role, :first_name, :last_name, :email, :phone, :gender, :birthday, :city_id]), :filename => 'users.xls'}
    end
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
   @jobs = Job.all
   @cities = City.all
   @teams = Team.all
   redirect_to edit_user_path(@user) if @user.first_name.nil? # push down to model
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      if params[:user][:photo].nil?
        @user.photo = nil
        @user.photo.save
      end
      flash[:notice] = "User has been updated."
      redirect_to user_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Your user has been destroyed."
    redirect_to users_path
  end

private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :photo, :password, :password_confirmation, :role, :city_id, :gender, :birthday, :photo, :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at)
  end
end

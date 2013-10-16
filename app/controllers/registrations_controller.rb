class RegistrationsController < Devise::RegistrationsController

  skip_before_filter :require_no_authentication, :only => [:new, :create]

  def new
    @user = User.new
    authorize! :create, @user
  end

  def create
    super
  end

  def edit
    super
  end

  def update
    super
  end

  def destroy
    super
  end
end 

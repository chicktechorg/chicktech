class CitiesController < ApplicationController

  skip_before_filter  :verify_authenticity_token
  
  authorize_resource
  def index
    @cities = City.all
    @city = City.new
  end

  def create
    @city = City.new(city_params)
     @city.save
      flash[:notice] = "#{@city.name} has been added."
      respond_to do |format|
        format.html { redirect_to user_path(current_user) }
        format.js
      end
  end

  def show
    @city = City.find(params[:id]) 
  end

  def destroy
    @city = City.find(params[:id])
    @city.destroy
    flash[:notice] = "#{@city.name} has been deleted."
      respond_to do |format|
        format.html { redirect_to user_path(current_user) }
        format.js
      end
  end

private

  def city_params
    params.require(:city).permit(:name)
  end
end

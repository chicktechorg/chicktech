class CitiesController < ApplicationController

  def index
    @cities = City.all
    @city = City.new
  end

  def create
    @city = City.new(city_params)
    if @city.save
      flash[:notice] = "#{@city.name} has been added."
      redirect_to cities_path
    else
      flash[:alert] = "City name cannot be blank"
      redirect_to cities_path
    end
  end

  def show
    @city = City.find(params[:id])
  end

  def destroy
    @city = City.find(params[:id])
    @city.destroy
    flash[:alert] = "#{@city.name} has been deleted."
    redirect_to cities_path
  end

private

  def city_params
    params.require(:city).permit(:name)
  end
end
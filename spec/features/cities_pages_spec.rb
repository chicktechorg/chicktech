require 'spec_helper'

feature "City pages" do
  subject { page }

  context "viewing all cities" do
    before do
      @city = FactoryGirl.create(:city)
      visit cities_path
    end

    it { should have_content @city.name }
  end

  context "viewing one city" do
    before do
      @city = FactoryGirl.create(:city)
      @event = FactoryGirl.create(:event, :city_id => @city.id)
      @event2 = FactoryGirl.create(:event, :city_id => 0)
      visit city_path(@city)
    end

    it { should have_content @event.name }
    it { should_not have_content @event2.name }
  end

  context "adding cities" do
    before { visit cities_path }

    scenario "with valid input" do
      fill_in 'Name', with: 'San Francisco, CA'
      click_on 'Add'
      page.should have_content 'San Francisco, CA'
    end

    scenario "with invalid input" do
      click_on 'Add'
      page.should have_content 'blank'
    end
  end

  context "removing cities" do
    before do
      @city = FactoryGirl.create(:city)
      visit cities_path
      click_on '(remove)'
    end

    it "should not show deleted city" do
      visit cities_path
      page.should_not have_content @city.name
    end

    it { should have_content 'Cities' }
  end
end
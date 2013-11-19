require 'spec_helper'

feature "City pages" do
  subject { page }
  let(:volunteer) { FactoryGirl.create(:volunteer) }
  let(:admin) { FactoryGirl.create(:admin) }

  context "when signed in as volunteer" do
    before { sign_in(volunteer) }

    it "should show the add city form" do
      visit cities_path
      page.should have_no_field('Name')
    end

    context "viewing all cities" do
      before do
        @city = FactoryGirl.create(:city)
        visit cities_path
      end

      it { should have_content @city.name }

      it "should link to the show page for each city" do
        click_link @city.name
        page.should have_content 'Events around'
      end
    end

    context "viewing one city" do
      before do
        @city = FactoryGirl.create(:city)
        @city2 = FactoryGirl.create(:city, :name => "Seattle, WA")
        @event = FactoryGirl.create(:event, :city_id => @city.id)
        @event2 = FactoryGirl.create(:event, :city_id => @city2.id)
        visit city_path(@city)
      end

      it { should have_content @event.name }
      it { should_not have_content @event2.name }
    end
  end

  context "when signed in as admin" do
    before { sign_in(admin) }

    it "should show the add city form" do
      visit cities_path
      page.should have_field('Name')
    end

    context "adding cities", js: true do
      before { click_on 'Add or Remove a city' }

      scenario "with valid input" do
        fill_in 'Name', with: 'San Francisco, CA'
        page.save_screenshot('screenshot.png')
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
        click_on 'X'
      end

      it "should not show deleted city" do
        visit cities_path
        page.should_not have_content @city.name
      end
    end
  end
end

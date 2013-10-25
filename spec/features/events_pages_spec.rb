require 'spec_helper'

feature "Creating events" do
  let(:admin) { FactoryGirl.create(:admin) }
  before { FactoryGirl.create(:city) }

  scenario "with valid input" do
    sign_in(admin)
    visit new_event_path
    fill_in 'Name', with: 'Example event'
    fill_in 'Description', with: 'Example event description'
    select 'December', from: 'event_start_2i'
    select '15', from: 'event_start_3i'
    select 'December', from: 'event_finish_2i'
    select '15', from: 'event_finish_3i'
    select '30', from: 'event_finish_5i'
    select  'Portland, OR', from: 'event[city_id]'
    click_on "Create Event"
    expect(page).to have_content "successfully"
  end

  scenario "without valid input" do
    sign_in(admin)
    visit new_event_path
    click_on "Create Event"
    page.should have_content "blank"
  end

  scenario "not logged in as admin" do
    visit new_event_path
    page.should have_content "Access denied."
  end
end

feature "Listing events" do
  let(:volunteer) { FactoryGirl.create(:volunteer) }
  before { @city = FactoryGirl.create(:city) }

  scenario "with several events" do
    sign_in(volunteer)
    event_1 = FactoryGirl.create(:event, :city_id => @city.id)
    event_2 = FactoryGirl.create(:event, :city_id => @city.id)
    visit events_path
    page.should have_content event_1.name
    page.should have_content event_2.name
  end

  scenario "not signed in" do
    event_1 = FactoryGirl.create(:event, :city_id => @city.id)
    event_2 = FactoryGirl.create(:event, :city_id => @city.id)
    visit events_path
    page.should have_content "Access denied"
  end
end

feature "Adding a job" do
  before { @city = FactoryGirl.create(:city) }
  scenario "signed in as admin" do
    admin = FactoryGirl.create(:admin)
    event_1 = FactoryGirl.create(:event, :city_id => @city.id)
    event_2 = FactoryGirl.create(:event, :city_id => @city.id)
    sign_in(admin)
    select  'Portland, OR', from: 'city[city_id]'
    click_on 'Search'
    click_on(event_1.name)
    page.should have_content "Add jobs"
  end
  
  scenario "signed in as volunteer" do
    volunteer = FactoryGirl.create(:volunteer)
    event_1 = FactoryGirl.create(:event, :city_id => @city.id)
    event_2 = FactoryGirl.create(:event, :city_id => @city.id)
    sign_in(volunteer)
    select  'Portland, OR', from: 'city[city_id]'
    click_on 'Search'
    click_on(event_1.name)
    page.should_not have_content "Add jobs"
  end
end

feature "Signing up for jobs" do
  let(:volunteer) { FactoryGirl.create(:volunteer) }
  let(:admin) { FactoryGirl.create(:admin) }
  before { @city = FactoryGirl.create(:city) }
  
  scenario "signed in" do
    event = FactoryGirl.create(:event, :city_id => @city.id)
    job = FactoryGirl.create(:job, :event_id => event.id) 
    sign_in(volunteer)
    select  'Portland, OR', from: 'city[city_id]'
    click_on 'Search'
    click_on(event.name)
    page.should have_button "Sign Up!"
  end

  scenario "signing up for a job" do
    event = FactoryGirl.create(:event, :city_id => @city.id)
    job = FactoryGirl.create(:job, :event_id => event.id) 
    sign_in(volunteer)
    select  'Portland, OR', from: 'city[city_id]'
    click_on 'Search'
    click_on(event.name)
    click_on "Sign Up!"
    page.should have_content "Congratulations"
  end

  scenario "job is already taken" do
    event = FactoryGirl.create(:event, :city_id => @city.id)
    job = FactoryGirl.create(:job, :event_id => event.id) 
    sign_in(volunteer)
    select  'Portland, OR', from: 'city[city_id]'
    click_on 'Search'
    click_on(event.name)
    click_on "Sign Up!"
    page.should_not have_button "Sign Up!"
    page.should have_button "Resign!"
  end

  scenario "jobs are taken by other users" do
    event = FactoryGirl.create(:event, :city_id => @city.id)
    job = FactoryGirl.create(:job, :event_id => event.id) 
    sign_in(volunteer)
    select  'Portland, OR', from: 'city[city_id]'
    click_on 'Search'
    click_on(event.name)
    click_on "Sign Up!"
    click_on "Sign out"
    sign_in(admin)
    select  'Portland, OR', from: 'city[city_id]'
    click_on 'Search'
    click_on(event.name)
    page.should_not have_button "Sign Up!"
    page.should_not have_button "Resign!"
    page.should have_content "Taken by"
  end
end

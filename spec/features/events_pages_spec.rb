require 'spec_helper'

feature "Creating events" do

  scenario "with valid input" do
    visit new_event_path
    fill_in 'Name', with: 'Example event'
    fill_in 'Description', with: 'Example event description'
    select 'December', from: 'event_start_2i'
    select '15', from: 'event_start_3i'
    select 'December', from: 'event_finish_2i'
    select '15', from: 'event_finish_3i'
    select '30', from: 'event_finish_5i'
    click_on "Create Event"
    expect(page).to have_content "successfully"
  end

  scenario "without valid input" do
    visit new_event_path
    click_on "Create Event"
    page.should have_content "blank"
  end

end

feature "Listing events" do 

  scenario "with several events" do
    event_1 = FactoryGirl.create(:event)
    event_2 = FactoryGirl.create(:event)
    visit events_path
    page.should have_content event_1.name
    page.should have_content event_2.name
  end

end

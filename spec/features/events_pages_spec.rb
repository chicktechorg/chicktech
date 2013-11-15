require 'spec_helper'

feature "Creating events" do
  let(:admin) { FactoryGirl.create(:admin) }
  before { FactoryGirl.create(:city) }

  scenario "with valid input" do
    sign_in(admin)
    visit new_event_path
    fill_in 'Name', with: 'Example event'
    fill_in 'Description', with: 'Example event description'
    fill_in 'event_start', with: 'December 25'
    # select '27', from: 'datetimepicker-days'
    fill_in 'event_finish', with: 'December 26'
    # select '28', from: 'datetimepicker-days'
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

  scenario "with several events" do
    sign_in(volunteer)
    event_1 = FactoryGirl.create(:event)
    event_2 = FactoryGirl.create(:event)
    visit events_path
    page.should have_content event_1.name
    page.should have_content event_2.name
  end

  scenario "not signed in" do
    event_1 = FactoryGirl.create(:event)
    event_2 = FactoryGirl.create(:event)
    visit events_path
    page.should have_content "Access denied"
  end
end

feature "Adding a job" do
  scenario "signed in as admin" do
    admin = FactoryGirl.create(:admin)
    event = FactoryGirl.create(:event)
    sign_in(admin)
    click_on(event.name)
    page.should have_content "Add jobs"
  end
  
  scenario "signed in as volunteer" do
    volunteer = FactoryGirl.create(:volunteer)
    event_1 = FactoryGirl.create(:event)
    event_2 = FactoryGirl.create(:event)
    sign_in(volunteer)
    click_on(event_1.name)
    page.should_not have_content "Add jobs"
  end
end

feature "Adding a team" do
  context "as an admin" do
    let(:admin) { FactoryGirl.create(:admin) }

    it "page should have content 'Add a team'" do
      event = FactoryGirl.create(:event)
      sign_in(admin)
      click_link(event.name)
      page.should have_content "Add a team"
    end
  end

  context "as an event leader" do
    it "page should have content 'Add a team'" do
      event = FactoryGirl.create(:event)
      sign_in(event.leader)
      click_on(event.name)
      page.should have_content "Add a team"
    end
  end
end

feature "Signing up to be an Event Leader" do
  let(:volunteer) { FactoryGirl.create(:volunteer) }

  context "when there is no leader" do
    it "should have a button to become the leader" do
      sign_in(volunteer)
      @event = FactoryGirl.create(:event)
      @event.leadership_role.user_id = nil
      @event.leadership_role.save
      visit event_path(@event)
      page.should have_button('Take the lead!')
    end
  end

  context "when there is a leader" do
    before do
      sign_in(volunteer)
      @event = FactoryGirl.create(:event)
      @leadership_role = FactoryGirl.create(:leadership_role, leadable: @event)
      visit event_path(@event)
    end

    it "should not have a button to become the leader" do
      page.should_not have_button('Take the lead!')
    end

    it "should show the leader's name" do
      page.should have_content @event.leader.first_name
    end
  end
end

feature "Signing up for jobs" do
  let(:volunteer) { FactoryGirl.create(:volunteer) }
  let(:admin) { FactoryGirl.create(:admin) }
  
  scenario "signed in" do
    event = FactoryGirl.create(:event)
    event.jobs << FactoryGirl.create(:job) 
    sign_in(volunteer)
    click_on(event.name)
    page.should have_button "Sign Up!"
  end

  scenario "signing up for a job" do
    event = FactoryGirl.create(:event)
    event.jobs << FactoryGirl.create(:job) 
    sign_in(volunteer)
    click_on(event.name)
    click_on "Sign Up!"
    page.should have_content "Congratulations"
  end

  scenario "job is already taken" do
    @event = FactoryGirl.create(:event)
    @event.jobs << FactoryGirl.create(:job) 
    sign_in(volunteer)
    click_on(@event.name)
    click_on "Sign Up!"
    page.should_not have_button "Sign Up!"
    page.should have_button "Resign!"
  end

  scenario "jobs are taken by other users" do
    event = FactoryGirl.create(:event)
    event.jobs << FactoryGirl.create(:job) 
    sign_in(volunteer)
    click_on(event.name)
    click_on "Sign Up!"
    click_on "Sign out"
    sign_in(admin)
    click_on(event.name)
    page.should_not have_button "Sign Up!"
    page.should have_content "Taken by"
  end
end

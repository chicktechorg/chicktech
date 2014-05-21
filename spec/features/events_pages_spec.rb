require 'spec_helper'

feature "Creating events" do
  let(:admin) { FactoryGirl.create(:admin) }
  before { @city = FactoryGirl.create(:city) }

  scenario "with valid input" do
    sign_in(admin)
    visit new_event_path
    fill_in 'Name', with: 'Example event'
    fill_in 'Description', with: 'Example event description'
    fill_in 'event_start', with: 'December 25'
    fill_in 'event_finish', with: 'December 26'
    select @city.name, from: 'event[city_id]'
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

  scenario "with several events", :js => true do
    sign_in(volunteer)
    event_1 = FactoryGirl.create(:event, :city_id => @city.id)
    event_2 = FactoryGirl.create(:event, :city_id => @city.id)
    visit events_path
    select @city.name, from: 'city_id'
    click_on "Filter"
    page.should have_content event_1.name
    page.should have_content event_2.name
  end

  scenario "which have passed" do
    sign_in(volunteer)
    six_hours_from_now = Time.now + 6.hours
    event_1 = FactoryGirl.create(:event, :city_id => @city.id)
    event_2 = FactoryGirl.create(:event, :city_id => @city.id)
    Time.stub(:now).and_return(six_hours_from_now)
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

feature 'Calendar view' do
  let(:volunteer) { FactoryGirl.create(:volunteer) }
  before(:each) { sign_in(volunteer) }

  scenario 'shows events in current month' do
    event = FactoryGirl.create(:event)
    visit events_path
    within('#events-calendar') do
      page.should have_content event.name
    end
  end

  scenario 'view events in the previous month' do
    one_month_ago = Time.now - 1.month
    Time.stub(:now).and_return(one_month_ago)
    event = FactoryGirl.build(:event, start: Time.now + 1.day, finish: Time.now + 2.days)
    event.save(validate: false)
    visit events_path
    click_on "<"
    within('#events-calendar') do
      page.should have_content event.name
    end
  end

  scenario 'view events in the next month' do
    event = FactoryGirl.create(:event, start: Time.now + 1.month, finish: Time.now + 1.month + 1.day)
    visit events_path
    click_on '>'
    within('#events-calendar') do
      page.should have_content event.name
    end
  end

  scenario 'listed events link to their show page' do
    event = FactoryGirl.create(:event)
    visit events_path
    within('#events-calendar') do
      click_link event.name
    end
    page.should have_content event.description
  end
end

feature 'Table view' do
  let(:volunteer) { FactoryGirl.create(:volunteer) }
  before(:each) { sign_in(volunteer) }

  scenario 'shows all events in the table' do
    event = FactoryGirl.create(:event)
    visit events_path
    within('#events-table') do
      page.should have_content event.name
    end
  end

  scenario 'shows the leader of an event if there is one' do
    event = FactoryGirl.create(:event_without_leader)
    visit event_path(event)
    click_button "Take the lead!"
    visit events_path
    page.should have_content volunteer.first_name
  end

  scenario 'shows the number of teams and how many have leaders for each event' do
    team_with_leader = FactoryGirl.create(:team_with_leader)
    team_with_leader.event.teams << team_without_leader = Team.create(:name => "Team Without Leader")
    visit events_path
    within('.table-teams') do
      page.should have_content team_with_leader.event.teams.with_leaders.count
      page.should have_content team_with_leader.event.teams.count
    end
  end

  scenario 'the number should be red if no teams have leaders' do
    team_without_leader = FactoryGirl.create(:team)
    visit events_path
    within('.table-teams') do
      within('.red') do
        page.should have_content team_without_leader.event.teams.with_leaders.count
      end
    end
  end

  scenario 'the number should be yellow if at least one (but not all) of the teams have leaders' do
    team_with_leader = FactoryGirl.create(:team_with_leader)
    team_without_leader = Team.create(:name => "Team Without Leader")
    team_with_leader.event.teams << team_without_leader
    visit events_path
    within('.table-teams') do
      within ('.yellow') do
        page.should have_content team_without_leader.event.teams.with_leaders.count
      end
    end
  end

  scenario 'the number should be green if all teams have leaders' do
    team_with_leader = FactoryGirl.create(:team_with_leader)
    visit events_path
    within('.table-teams') do
      within first('.green') do
        page.should have_content team_with_leader.event.teams.with_leaders.count
      end
    end
  end

  scenario 'shows the number of jobs and how many have volunteers for each event' do
    job_a = FactoryGirl.create(:job)
    job_a.workable.jobs << job_b = Job.create(:name => "Job B")
    visit event_path(job_a.workable)
    within('#edit_job_'+job_a.id.to_s) do
      click_on "Sign Up!"
    end
    visit events_path
    page.should have_content job_a.workable.jobs.with_volunteers.count
    page.should have_content job_a.workable.jobs.count
  end

  scenario 'the number should be red if no jobs have volunteers' do
    job = FactoryGirl.create(:job)
    visit events_path
    within('.table-jobs') do
      within('.red') do
        page.should have_content job.workable.jobs.with_volunteers.count
      end
    end
  end

  scenario 'the number should be yellow if at least one (but not all) of the jobs have volunteers' do
    job_a = FactoryGirl.create(:job)
    job_b = Job.create(:name => "Job B")
    job_a.workable.jobs << job_b
    visit event_path(job_a.workable)
    within('#edit_job_'+job_a.id.to_s) do
      click_on "Sign Up!"
    end
    visit events_path
    within('.table-jobs') do
      within ('.yellow') do
        page.should have_content job_a.workable.jobs.with_volunteers.count
      end
    end
  end

  scenario 'the number should be green if all jobs have volunteerss' do
    job_a = FactoryGirl.create(:job)
    job_b = Job.create(:name => "Job B")
    job_a.workable.jobs << job_b
    visit event_path(job_a.workable)
    within('#edit_job_'+job_a.id.to_s) do
      click_on "Sign Up!"
    end
    within('#edit_job_'+job_b.id.to_s) do
      click_on "Sign Up!"
    end
    visit events_path
    within('.table-jobs') do
      within first('.green') do
        page.should have_content job_a.workable.jobs.with_volunteers.count
      end
    end
  end

end

feature 'Listing events by city' do
  let(:volunteer) { FactoryGirl.create(:volunteer) }
  let(:city_1) { FactoryGirl.create(:city, name: 'Portland') }
  let(:city_2) { FactoryGirl.create(:city, name: 'Seattle') }
  before(:each) do
    sign_in(volunteer)
  end
  scenario 'shows only events within the selected city' do
    event_1 = FactoryGirl.create(:event, :city => city_1)
    event_2 = FactoryGirl.create(:event, :city => city_2)
    visit events_path
    select city_2.name, :from => 'city_id'
    click_button 'Filter'
    page.should have_content event_2.name
    page.should_not have_content event_1.name
  end
end

feature "Adding a job" do
  scenario "signed in as admin" do
    admin = FactoryGirl.create(:admin)
    event = FactoryGirl.create(:event)
    sign_in(admin)
    visit event_path(event)
    page.should have_content "Add jobs"
  end

  scenario "signed in as volunteer", js: true do
    volunteer = FactoryGirl.create(:volunteer)
    event_1 = FactoryGirl.create(:event)
    event_2 = FactoryGirl.create(:event, city: event_1.city)
    sign_in(volunteer)
    visit events_path
    select  event_1.city.name, from: 'city_id'
    click_on 'Filter'
    within('#events-calendar') do
      click_on(event_1.name)
    end
    page.should_not have_content "Add jobs"
  end
end

feature "Adding a team" do
  context "as an admin" do
    let(:admin) { FactoryGirl.create(:admin) }

    it "page should have content 'Add a team'" do
      event = FactoryGirl.create(:event)
      sign_in(admin)
      visit event_path(event)
      page.should have_content "Add a team"
    end
  end

  context "as an event leader" do
    it "page should have content 'Add a team'" do
      event = FactoryGirl.create(:event)
      sign_in(event.leader)
      visit event_path(event)
      page.should have_content "Add a team"
    end
  end
end

feature "Unassigning an event leader" do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:volunteer) { FactoryGirl.create(:volunteer) }

  scenario "as an admin" do
    event = FactoryGirl.create(:event)
    leadership_role = FactoryGirl.create(:leadership_role, leadable: event, user: volunteer)
    sign_in(admin)
    visit event_path(event)
    page.should have_content "Unassign"
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

  scenario "signing up for a job", js: true do
    job = FactoryGirl.create(:job)
    sign_in(volunteer)
    visit events_path
    within('#events-calendar') do
      click_on(job.workable.name)
    end
    click_on "Sign Up!"
    page.should have_content "Congratulations"
  end

  scenario "job is already taken", js: true do
    job = FactoryGirl.create(:job)
    sign_in(volunteer)
    visit event_path(job.workable)
    click_on "Sign Up!"
    click_on "Sign out"
    sign_in(admin)
    visit event_path(job.workable)
    page.should_not have_content "Sign Up!"
  end

  scenario "jobs are taken by other users", js: true do
    job = FactoryGirl.create(:job)
    sign_in(volunteer)
    visit events_path
    within('#events-calendar') do
      click_on(job.workable.name)
    end
    click_on "Sign Up!"
    click_on "Sign out"
    sign_in(admin)
    visit events_path
    within('#events-calendar') do
      click_on(job.workable.name)
    end
    page.should_not have_button "Sign Up!"
    page.should have_content "Taken by"
  end
end

feature "Showing all jobs on the page" do
  let(:volunteer) { FactoryGirl.create(:volunteer) }

  scenario "job is part of a team" do
    job = FactoryGirl.create(:team_job)
    sign_in(volunteer)
    visit team_path(job.workable)
    page.should_not have_content "No jobs have been created for this event"
  end
end

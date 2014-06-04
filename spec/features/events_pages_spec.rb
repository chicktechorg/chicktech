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

  scenario "with template" do
    @template = FactoryGirl.create(:template)
    sign_in(admin)
    visit new_event_path
    fill_in 'Name', with: 'Example event'
    fill_in 'Description', with: 'Example event description'
    fill_in 'event_start', with: 'December 25'
    fill_in 'event_finish', with: 'December 26'
    select @city.name, from: 'event[city_id]'
    select @template.name, from: 'event[template_id]'
    click_on "Create Event"
    expect(page).to have_content "with template"
  end
end

feature "Send volunteer invitations button" do
  let(:superadmin) { FactoryGirl.create(:superadmin) }
  let(:event) { FactoryGirl.create(:event, :city_id => superadmin.city.id)}
  before(:each) { sign_in(superadmin) }

  scenario 'send email containing number of open positions' do
    rand(5).times { FactoryGirl.create(:volunteer, city: event.city) }
    visit event_path(event)
    click_button "Send volunteer invitations"
    ActionMailer::Base.deliveries.count.should eq event.city.users.count
  end

  scenario 'contents of email sent with only one position' do
    job = FactoryGirl.create(:job)
    mail = UserMailer.invite_volunteer(superadmin, job.workable)
    mail.subject.should eq "#{job.workable.name} has 1 more position to be filled"
    mail.to.should eq [superadmin.email]
    mail.from.should eq ['noreply@chicktech.herokuapp.com']
    mail.body.encoded.should have_content(superadmin.first_name)
  end

  scenario 'contents of email sent with more than one position' do
    job_a = FactoryGirl.create(:job)
    job_b = FactoryGirl.create(:job, :workable => job_a.workable)
    mail = UserMailer.invite_volunteer(superadmin, job_a.workable)
    mail.subject.should eq "#{job_a.workable.name} has 2 more positions to be filled"
    mail.to.should eq [superadmin.email]
    mail.from.should eq ['noreply@chicktech.herokuapp.com']
    mail.body.encoded.should have_content(superadmin.first_name)
  end
end

feature "Listing events" do
  let(:volunteer) { FactoryGirl.create(:volunteer) }
  before { @city = FactoryGirl.create(:city) }

  scenario "with several events", :js => true do
    sign_in(volunteer)
    event_1 = FactoryGirl.create(:event, city: volunteer.city)
    event_2 = FactoryGirl.create(:event, city: volunteer.city)
    visit events_path
    page.should have_content event_1.name
    page.should have_content event_2.name
  end

  scenario "which have passed" do
    sign_in(volunteer)
    six_hours_from_now = Time.now + 6.hours
    event_1 = FactoryGirl.create(:event, city: volunteer.city)
    event_2 = FactoryGirl.create(:event, city: volunteer.city)
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
  let(:superadmin) { FactoryGirl.create(:superadmin) }
  before(:each) { sign_in(superadmin) }

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

  scenario 'shows all events, filtered by the users city, in the table' do
    volunteer_event = FactoryGirl.create(:event, city: volunteer.city)
    non_volunteer_event = FactoryGirl.create(:event)
    visit events_path
    within('#events-table') do
      page.should have_content volunteer_event.name
      page.should_not have_content non_volunteer_event.name
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
    superadmin = FactoryGirl.create(:superadmin)
    click_on "Sign out"
    sign_in(superadmin)
    team_with_leader = FactoryGirl.create(:team_with_leader)
    team_with_leader.event.teams << team_without_leader = Team.create(:name => "Team Without Leader")
    visit events_path
    within('#events-table') do
      page.should have_content team_with_leader.event.teams.with_leaders.count
      page.should have_content team_with_leader.event.teams.count
    end
    within('#upcoming-table') do
      page.should have_content team_with_leader.event.teams.with_leaders.count
      page.should have_content team_with_leader.event.teams.count
    end
  end

  scenario 'shows the number of jobs and how many have volunteers for each event', js: true do
    event = FactoryGirl.create(:event, city: volunteer.city)
    job_without_volunteer = FactoryGirl.create(:job, workable: event)
    job_with_volunteer = FactoryGirl.create(:job, workable: event, user: volunteer)
    visit events_path(city_id: volunteer.city.id)
    within '#events-table' do
      page.should have_content '1/2'
    end
  end
end

feature 'Listing events by city' do
  let(:superadmin) { FactoryGirl.create(:superadmin) }
  let(:city_1) { FactoryGirl.create(:city, name: 'Portland') }
  let(:city_2) { FactoryGirl.create(:city, name: 'Seattle') }
  before(:each) do
    sign_in(superadmin)
  end
  scenario 'shows only events within the selected city' do
    event_1 = FactoryGirl.create(:event, :city => city_1)
    event_2 = FactoryGirl.create(:event, :city => city_2)
    visit events_path
    select city_2.name, :from => 'city_id'
    click_button 'Filter'

    within "#events-table" do
      page.should have_content event_2.name
      page.should_not have_content event_1.name
    end
  end

  scenario 'shows city name in the dropdown' do
    event_1 = FactoryGirl.create(:event, :city => city_1)
    event_2 = FactoryGirl.create(:event, :city => city_2)
    visit events_path
    select city_2.name, :from => 'city_id'
    click_button 'Filter'
    within '#city_id' do
      page.should have_content city_2.name
    end
  end
end

feature "Adding a job" do
  scenario "signed in as admin" do
    admin = FactoryGirl.create(:admin)
    event = FactoryGirl.create(:event)
    sign_in(admin)
    visit event_path(event)
    page.should have_content "Add job"
  end

  scenario "signed in as volunteer", js: true do
    volunteer = FactoryGirl.create(:volunteer)
    sign_in(volunteer)
    event = FactoryGirl.create(:event, city: volunteer.city)
    visit events_path
    within('#events-calendar') do
      click_on(event.name)
    end
    page.should_not have_content "Add jobs"
  end
end

feature "Adding a team" do
  context "as an admin" do
    let(:admin) { FactoryGirl.create(:admin) }

    it "page should have content 'Add team'" do
      event = FactoryGirl.create(:event)
      sign_in(admin)
      visit event_path(event)
      page.should have_content "Add team"
    end
  end

  context "as an event leader" do
    it "page should have content 'Add team'" do
      event = FactoryGirl.create(:event)
      sign_in(event.leader)
      visit event_path(event)
      page.should have_content "Add team"
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
    event = FactoryGirl.create(:event, city: volunteer.city)
    job = FactoryGirl.create(:job, workable: event)
    sign_in(volunteer)
    visit events_path
    within('#events-calendar') do
      click_on(job.workable.name)
    end
    click_on "Take the Lead!"
    page.should have_content "Congratulations"
  end

  scenario "job is already taken", js: true do
    job = FactoryGirl.create(:job)
    sign_in(volunteer)
    visit event_path(job.workable)
    click_on "Take the Lead!"
    click_on "Sign out"
    sign_in(admin)
    visit event_path(job.workable)
    page.should_not have_content "Take the Lead!"
  end

  scenario "jobs are taken by other users", js: true do
    event = FactoryGirl.create(:event, city: volunteer.city)
    job = FactoryGirl.create(:job, workable: event)
    sign_in(volunteer)
    visit events_path
    within('#events-calendar') do
      click_on(job.workable.name)
    end
    click_on "Take the Lead!"
    click_on "Sign out"
    sign_in(admin)
    visit events_path
    within('#events-calendar') do
      click_on(job.workable.name)
    end
    page.should_not have_button "Take the Lead!"
    page.should have_content "Leader:"
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

feature "saving a template"  do
 let(:volunteer) { FactoryGirl.create(:volunteer) }

  scenario "from the event show page" do
    @event = FactoryGirl.create(:event)
    sign_in(volunteer)
    visit event_path(@event)
    click_on "Save as Template"
    page.should have_content "Template saved"
    Template.all.count.should eq 1
  end
end




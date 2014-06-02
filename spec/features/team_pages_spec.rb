require 'spec_helper'

feature 'Adding a team' do
  let(:admin) { FactoryGirl.create(:admin) }
  before do
    @event = FactoryGirl.create(:event)
    sign_in(admin)
  end

  scenario 'navigating to the add team page' do
    visit event_path(@event)
    click_on 'Add team'
    page.should have_content "Add a team to #{@event.name}"
  end

  scenario 'filling incorrect information' do
    visit new_team_path(team: { event_id: @event.id })
    click_on "Submit"
    page.should have_content 'blank'
    page.should_not have_content 'Team added!'
  end

  scenario 'filling correct information' do
    visit new_team_path(team: { event_id: @event.id })
    fill_in 'Name', with: 'Logistics'
    click_on "Submit"
    page.should have_content 'Team added!'
  end
end

feature 'Showing a team' do
  let(:admin) { FactoryGirl.create(:admin) }
  before do
    @team = FactoryGirl.create(:team)
    sign_in(admin)
  end

  scenario 'navigating to the show page' do
    visit event_path(@team.event)
    click_on @team.name
    page.should have_content @team.name
  end

  it "should have a list of jobs within that team" do
    @job = FactoryGirl.create(:job, workable: @team)
    visit event_path(@team.event)
    page.should have_content @job.name
  end
end

feature 'Editing a team' do
  let(:admin) { FactoryGirl.create(:admin) }
  before do
    @team = FactoryGirl.create(:team)
    sign_in(admin)
  end

  scenario 'navigating to the edit page' do
    visit team_path(@team)
    click_on 'Edit'
    page.should have_content "Edit #{@team.name}"
  end

  scenario 'filling in incorrect information' do
    visit edit_team_path(@team)
    fill_in 'Name', with: ''
    click_on 'Submit'
    page.should have_content 'blank'
    page.should_not have_content 'Team updated!'
  end

  scenario 'filling in correct information' do
    visit edit_team_path(@team)
    fill_in 'Name', with: 'New team name'
    click_on 'Submit'
    page.should have_content 'New team name'
    page.should have_content 'Team updated!'
  end
end

feature 'Destroying a team' do
  let(:admin) { FactoryGirl.create(:admin) }
  before do
    @team = FactoryGirl.create(:team)
    sign_in(admin)
  end

  # I think this link should exist soley on the team show page

  # context 'when visiting event page' do
    # before do
    #   visit event_path(@team.event)
    #   within('p.team') do
    #     click_on 'Delete'
    #   end
    # end
    # subject { page }

    # it { should_not have_content @team.name }
    # it { should have_content 'Team deleted.'}
  # end

  # context 'when visiting team show page' do
  #   before do
  #     visit team_path(@team)
  #     click_on 'Delete'
  #   end
  #   subject { page }

  #   it { should_not have_content @team.name }
  #   it { should have_content 'Team deleted.'}
  # end
end

feature "Signing up to be an Team Leader" do
  let(:volunteer) { FactoryGirl.create(:volunteer) }

  context "when there is no leader" do
    it "should have a button to become the leader" do
      sign_in(volunteer)
      @team = FactoryGirl.create(:team)
      visit team_path(@team)
      page.should have_button('Take the lead!')
    end
  end

  context "when there is a leader" do
    before do
      sign_in(volunteer)
      @team = FactoryGirl.create(:team_with_leader)
      visit team_path(@team)
    end

    it "should not have a button to become the leader" do
      page.should_not have_button('Take the lead!')
    end

    it "should show the leader's name" do
      page.should have_content @team.leader.first_name
    end
  end
end

feature "Adding comments to teams" do
  let(:volunteer) { FactoryGirl.create(:volunteer) }
  let(:team) { FactoryGirl.create(:team) }
  before { sign_in(volunteer) }

  scenario "successfully" do
    visit team_path(team)
    click_on 'Comment'
    fill_in 'Add a comment', with: 'Stuff'
    click_on 'Create Comment'
    page.should have_content 'created'
  end

  scenario "unsuccessfully" do
    visit team_path(team)
    click_on 'Comment'
    click_on 'Create Comment'
    page.should have_content 'blank'
  end
end

feature "Team jobs" do
  let(:volunteer) { FactoryGirl.create(:volunteer) }

  it "should allow the team leader to add jobs" do
    sign_in(volunteer)
    @team = FactoryGirl.create(:team)
    volunteer.leadership_roles << @team.leadership_role
    visit team_path(@team)
    fill_in 'Name', with: 'Book the venue'
    fill_in 'Description', with: 'make sure it is done right!'
    click_on 'Create Job'
    page.should have_content "successfully"
  end

  it "should not allow another volunteer to add jobs" do
    @other_user = FactoryGirl.create(:volunteer)
    sign_in(@other_user)
    @team = FactoryGirl.create(:team)
    volunteer.leadership_roles << @team.leadership_role
    visit team_path(@team)
    page.should_not have_content "Add a job"
  end

  it "should prevent unauthorized posts to create users" do
    page.driver.submit :post, jobs_path(job: {name: 'This job', description: 'is awesome!', workable: 1, workable_type: 'Team'}), {}
    page.should have_content 'denied'
  end
end

feature "Admin can remove a leader" do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:team) { FactoryGirl.create(:team_with_leader) }
  before { sign_in(admin) }

  context "when there is a leader" do
    it "should have a button to unassign the leader" do
      event = FactoryGirl.create(:event)
      visit event_path(event)
      page.should have_content('Unassign')
    end
  end
end

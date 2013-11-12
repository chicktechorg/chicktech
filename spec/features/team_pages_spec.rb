require 'spec_helper'

feature 'Adding a team' do
  let(:admin) { FactoryGirl.create(:admin) }
  before do
    @event = FactoryGirl.create(:event)
    sign_in(admin)
  end

  scenario 'navigating to the add team page' do
    visit event_path(@event)
    click_on 'Add a team'
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
    visit team_path(@team)
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

  context 'when visiting event page' do
    before do
      visit event_path(@team.event)
      click_on '(delete)'
    end
    subject { page }

    it { should_not have_content @team.name }
    it { should have_content 'Team deleted.'}
  end

  context 'when visiting team show page' do
    before do
      visit team_path(@team)
      click_on 'Delete'
    end
    subject { page }

    it { should_not have_content @team.name }
    it { should have_content 'Team deleted.'}
  end
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


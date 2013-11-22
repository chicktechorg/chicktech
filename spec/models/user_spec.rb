
require 'spec_helper'

describe User do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :phone }
  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :role }

  it { should have_many(:jobs).dependent(:nullify) }
  it { should have_many(:events).through(:jobs) }
  it { should have_many(:comments)}
  it { should have_many(:teams).through(:jobs) }
  it { should have_many(:events_through_teams).through(:teams) }
  it { should have_many(:leadership_roles).dependent(:nullify) }
  it { should have_many(:event_leads) }
  it { should have_many(:team_leads) }

    describe '#events' do
      it "should only return unique events" do
        user = FactoryGirl.create(:volunteer)
        event = FactoryGirl.create(:event)
        job1 = FactoryGirl.create(:job, :user_id => user.id, workable_id: event.id, workable_type: 'Event')
        job2 = FactoryGirl.create(:job, :user_id => user.id, workable_id: event.id, workable_type: 'Event')
        user.events.should eq [event]
      end
    end

    describe '#all_events' do
      it "should return all the events associated with the user through jobs and leadership roles" do
        user = FactoryGirl.create(:volunteer)
        event1 = FactoryGirl.create(:event)
        event2 = FactoryGirl.create(:event)
        user.leadership_roles << event1.leadership_role
        user.jobs << FactoryGirl.create(:job, workable_id: event2.id, workable_type: 'Event')
        user.all_events.should eq [event1, event2]
      end

      it "should only return unique events" do
        user = FactoryGirl.create(:volunteer)
        event = FactoryGirl.create(:event)
        user.leadership_roles << event.leadership_role
        user.jobs << FactoryGirl.create(:job, workable_id: event.id, workable_type: 'Event')
        user.all_events.should eq [event]
      end
    end

    describe '#teams' do
      it "tells you each unique team it is signed up for" do
        user = FactoryGirl.create(:volunteer)
        team = FactoryGirl.create(:team)
        job1 = FactoryGirl.create(:job, :user_id => user.id, workable_id: team.id, workable_type: 'Team')
        job2 = FactoryGirl.create(:job, :user_id => user.id, workable_id: team.id, workable_type: 'Team')
        user.teams.should eq [team]
      end

      it "should only return unique teams" do
        user = FactoryGirl.create(:volunteer)
        team = FactoryGirl.create(:team)
        user.leadership_roles << team.leadership_role
        user.jobs << FactoryGirl.create(:job, workable_id: team.id, workable_type: 'Team')
        user.all_teams.should eq [team]
      end
    end

    describe '#all_teams' do
      it "should return all the events associated with the user through jobs and leadership roles" do
        user = FactoryGirl.create(:volunteer)
        team1 = FactoryGirl.create(:team)
        team2 = FactoryGirl.create(:team)
        user.leadership_roles << team1.leadership_role
        user.jobs << FactoryGirl.create(:job, workable_id: team2.id, workable_type: 'Team')
        user.all_teams.should eq [team1, team2]
      end
    end

  it "sends an e-mail" do
    user = FactoryGirl.create(:volunteer)
    user.send_information
    ActionMailer::Base.deliveries.last.to.should eq [user.email]
  end

  describe "pending" do
    it "tells you which users have pending invitations" do
      confirmed_user = FactoryGirl.create(:volunteer, :invitation_token => nil)
      pending_user = FactoryGirl.build(:volunteer, :invitation_token => 'sample token')
      pending_user.save(:validate => false)
      User.pending.should eq [pending_user]
    end
  end

  describe "confirmed" do
    it "tells you which users are confirmed users" do
      confirmed_user = FactoryGirl.create(:volunteer, :invitation_token => nil)
      pending_user = FactoryGirl.build(:volunteer, :invitation_token => 'sample token')
      pending_user.save(:validate => false)
      User.confirmed.should eq [confirmed_user]
    end
  end

  describe "commitment_events" do
    it "returns all the events in which the user has a commitment" do
      user = FactoryGirl.create(:volunteer)
      team_job = FactoryGirl.create(:team_job)
      team_leadership_role = team_job.workable.leadership_role
      event_job = FactoryGirl.create(:job)
      event_leadership_role = FactoryGirl.create(:event).leadership_role
      user.jobs << [team_job, event_job]
      user.leadership_roles << [team_leadership_role, event_leadership_role]
      user.commitment_events.should eq [team_job.workable.event, event_job.workable, event_leadership_role.leadable]
    end
  end
end

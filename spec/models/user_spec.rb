require 'spec_helper'

describe User do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :phone }
  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :role }

  it { should have_many(:jobs).dependent(:nullify) }
  it { should have_many(:events).through(:jobs) }
  it { should have_many(:teams).through(:jobs) }

  it "tells you each unique event it is signed up for" do
    user = FactoryGirl.create(:volunteer)
    event = FactoryGirl.create(:event)
    job1 = FactoryGirl.create(:job, :user_id => user.id, workable_id: event.id, workable_type: 'Event')
    job2 = FactoryGirl.create(:job, :user_id => user.id, workable_id: event.id, workable_type: 'Event')
    user.unique_events.should eq [event]
  end

  it "tells you each unique team it is signed up for" do
    user = FactoryGirl.create(:volunteer)
    team = FactoryGirl.create(:team)
    job1 = FactoryGirl.create(:job, :user_id => user.id, workable_id: team.id, workable_type: 'Team')
    job2 = FactoryGirl.create(:job, :user_id => user.id, workable_id: team.id, workable_type: 'Team')
    user.unique_teams.should eq [team]
  end

  it "sends an e-mail" do
    user = FactoryGirl.create(:volunteer)
    user.send_information
    ActionMailer::Base.deliveries.last.to.should eq [user.email]
  end
end

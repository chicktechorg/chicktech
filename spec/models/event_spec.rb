require 'spec_helper'

describe Event do
  it { should validate_presence_of :name }
  it { should validate_presence_of :start }
  it { should validate_presence_of :finish }
  it { should validate_presence_of :city_id }
  it { should accept_nested_attributes_for :leadership_role }
  it { should have_many :jobs }
  it { should have_many :teams }
  it { should have_one(:leadership_role).dependent(:destroy) }
  it { should belong_to :city }

  describe '.all' do
    it "should not return templates" do
      template = FactoryGirl.create(:template)
      event = FactoryGirl.create(:event)
      Event.all.any? { |temp| temp.name == template.name }.should be_false
      Event.all.any? { |temp| temp.name == event.name }.should be_true
    end
  end

  describe "#start" do
    it "should be valid if the event starts after the time it's created" do
      event = FactoryGirl.build(:event, :start => Time.now + 1.hour)
      event.should be_valid
    end

    it "should be invalid if the event starts before the time it's created" do
      event = FactoryGirl.build(:event, :start => 1.day.ago)
      event.should_not be_valid
    end
  end

  describe "validates finish time" do
    it "valid if after start time" do
      event_valid = FactoryGirl.build(:event)
      event_valid.should be_valid
    end

    it "invalid if before start time" do
      event_invalid = FactoryGirl.build(:event, :start => Time.now + 2.hours, :finish => Time.now + 1.hour)
      event_invalid.should_not be_valid
    end
  end

  describe ".upcoming" do
    it "returns only the upcoming events" do
      forty_minutes_from_now = Time.now + 40.minutes
      event1 = FactoryGirl.create(:event, :start => Time.now, :finish => Time.now + 3.hours)
      event2 = FactoryGirl.create(:event, :start => Time.now, :finish => Time.now + 30.minutes)
      Time.stub(:now).and_return(forty_minutes_from_now)
      Event.upcoming.should eq [event1]
    end
  end

  describe "past" do
    it "returns all past events" do
      six_hours_from_now = Time.now + 6.hours
      event1 = FactoryGirl.create(:event, :start => Time.now + 5.minutes, :finish => Time.now + 30.minutes)
      event2 = FactoryGirl.create(:event, :start => Time.now + 10.hours, :finish => Time.now + 12.hours)
      Time.stub(:now).and_return(six_hours_from_now)
      Event.past.should eq [event1]
    end
  end

  describe "default_scope" do
    it "sorts upcoming events by chronological order" do
      event1 = FactoryGirl.create(:event, :start => Time.now + 1.hour)
      event2 = FactoryGirl.create(:event, :start => Time.now + 12.hours, :finish => Time.now + 14.hours)
      event3 = FactoryGirl.create(:event, :start => Time.now + 10.hours, :finish => Time.now + 12.hours)
      Event.all.should eq [event1, event3, event2]
    end
  end

  describe "#leader" do
    it "tells you who the leader of the event is" do
      volunteer = FactoryGirl.create(:volunteer)
      leadership_role = FactoryGirl.create(:leadership_role, :user => volunteer)
      event = FactoryGirl.create(:event, :leadership_role => leadership_role)
      event.leader.should eq volunteer
    end
  end

  describe '#jobs_of_user' do
    it "returns all the jobs of an event that belong to the passed in user" do
      @user = FactoryGirl.create(:volunteer)
      @event = FactoryGirl.create(:event)
      @job_1 = FactoryGirl.create(:job, workable: @event, user: @user)
      @job_2 = FactoryGirl.create(:job, workable: @event)
      @event.jobs_of_user(@user).should eq [@job_1]
    end
  end

  describe '#teams_of_user' do
    let(:volunteer) { FactoryGirl.create(:volunteer) }

    it 'should return all teams that are lead by the passed in user' do
      team = FactoryGirl.create(:team)
      event = team.event
      volunteer.leadership_roles << team.leadership_role
      event.teams_of_user(volunteer).should eq [team]
    end

    it 'should return all teams that are lead by the passed in user' do
      job = FactoryGirl.create(:team_job)
      team = job.workable
      event = team.event
      volunteer.jobs << job
      event.teams_of_user(volunteer).should eq [team]
    end
  end
end

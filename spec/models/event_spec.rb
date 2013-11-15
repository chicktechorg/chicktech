require 'spec_helper'

describe Event do
  it { should validate_presence_of :name }
  it { should validate_presence_of :start }
  it { should validate_presence_of :finish }
  it { should accept_nested_attributes_for :leadership_role }
  it { should have_many :jobs }
  it { should have_many :teams }
  it { should have_one :leadership_role }
  it { should belong_to :city }

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

  describe "#finish" do
    it "should validate that the finish time is after the start time" do
      event_valid = FactoryGirl.build(:event)
      event_invalid = FactoryGirl.build(:event, :start => Time.now + 2.hours, :finish => Time.now + 1.hour)
      event_valid.should be_valid
      event_invalid.should_not be_valid
    end
  end

  describe ".upcoming" do
    it "returns only the upcoming events" do
      forty_minutes_from_now = Time.now + 40.minutes
      event = FactoryGirl.create(:event, :start => Time.now, :finish => Time.now + 3.hours)
      event2 = FactoryGirl.create(:event, :start => Time.now, :finish => Time.now + 30.minutes)
      Time.stub(:now).and_return(forty_minutes_from_now)
      Event.upcoming.should eq [event]
    end
  end

  describe ".sort_by_time" do
    it "sorts upcoming events by chronological order" do
      event1 = FactoryGirl.create(:event, :start => Time.now + 1.hour)
      event2 = FactoryGirl.create(:event, :start => Time.now + 12.hours, :finish => Time.now + 14.hours)
      event3 = FactoryGirl.create(:event, :start => Time.now + 10.hours, :finish => Time.now + 12.hours)
      Event.sort_by_time.should eq [event1, event3, event2]
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
end

require 'spec_helper'

describe Event do
  it { should validate_presence_of :name }
  it { should validate_presence_of :start }
  it { should validate_presence_of :finish }
  it { should have_many :jobs }

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

  it "returns only the upcoming events" do
    fourty_minutes_from_now = Time.now + 40.minutes
    event = FactoryGirl.create(:event, :start => Time.now + 1.hour)
    event2 = FactoryGirl.create(:event, :start => Time.now + 30.minutes)
    Time.stub(:now).and_return(fourty_minutes_from_now)
    Event.upcoming.should eq [event]
  end
end

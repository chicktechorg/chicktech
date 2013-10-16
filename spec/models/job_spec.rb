require 'spec_helper'

describe Job do 
  it { should belong_to :event }
  it { should belong_to :user }
  it { should validate_presence_of :name }
  it { should validate_presence_of :event_id }

  it "should return true if the job has been taken by the user" do 
    volunteer1 = FactoryGirl.create(:volunteer)
    event_1 = FactoryGirl.create(:event)
    job = FactoryGirl.create(:job, :event_id => event_1.id, :user_id => volunteer1.id)
    job.owned_by?(volunteer1).should eq true
  end
end
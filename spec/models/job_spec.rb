require 'spec_helper'

describe Job do 
  it { should belong_to :event }
  it { should belong_to :user }
  it { should validate_presence_of :name }
  it { should validate_presence_of :event_id }

  let(:volunteer) { FactoryGirl.create(:volunteer) }
  let(:event) { FactoryGirl.create(:event) }

  it "can tell you if the job has been taken by the user" do 
    job = FactoryGirl.create(:job, :event_id => event.id, :user_id => volunteer.id)
    job.owned_by?(volunteer).should eq true
  end

  it "can tell you whether it has been taken" do
    job = FactoryGirl.create(:job, :event_id => event.id, :user_id => volunteer.id)
    job.taken?.should eq true
  end
end
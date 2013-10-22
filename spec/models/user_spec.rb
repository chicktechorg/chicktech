require 'spec_helper'

describe User do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :phone }
  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :role }

  it { should have_many :jobs }
  it { should have_many(:events).through(:jobs) }

  it "tells you each unique event it is signed up for" do
    user = FactoryGirl.create(:volunteer)
    event = FactoryGirl.create(:event)
    job1 = FactoryGirl.create(:job, :user_id => user.id, :event_id => event.id)
    job2 = FactoryGirl.create(:job, :user_id => user.id, :event_id => event.id)
    user.unique_events.should eq [event]
  end

  it "sends an e-mail" do
    user = FactoryGirl.create(:volunteer)
    user.send_information
    ActionMailer::Base.deliveries.last.to.should eq [user.email]
  end

  it "removes all job associations when a user is deleted" do
    user = FactoryGirl.create(:volunteer)
    job1 = FactoryGirl.create(:job, :user_id => user.id)
    job2 = FactoryGirl.create(:job, :user_id => user.id)
    user.destroy
    job1.reload.user_id.should be_nil
    job2.reload.user_id.should be_nil
  end
end

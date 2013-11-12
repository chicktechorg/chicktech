require 'spec_helper'

describe Team do
  it { should validate_presence_of :name }
  it { should have_many :jobs }
  it { should belong_to :event }
  it { should have_one :leadership_role }

  it "should tell you its leader" do
    team = FactoryGirl.create(:team)
    volunteer = FactoryGirl.create(:volunteer)
    team.leadership_role.update(:user => volunteer)
    team.leader.should eq volunteer
  end

  it "should create a leadership role after it saves" do
    team = FactoryGirl.create(:team)
    team.leadership_role.should be_an_instance_of LeadershipRole
  end
end

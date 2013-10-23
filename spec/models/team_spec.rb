require 'spec_helper'

describe Team do
  it { should validate_presence_of :name }
  it { should have_many :jobs }
  it { should belong_to :event }
  it { should belong_to :leadership_role }

  it "should tell you its leader" do
    volunteer = FactoryGirl.create(:volunteer)
    leadership_role = FactoryGirl.create(:leadership_role, :user => volunteer)
    team = FactoryGirl.create(:team, :leadership_role => leadership_role)
    team.leader.should eq volunteer
  end
end

require 'spec_helper'

describe Team do
  it { should validate_presence_of :name }
  it { should have_many :jobs }
  it { should belong_to :event }
  it { should have_one(:leadership_role).dependent(:destroy) }

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

  describe '#jobs_of_user' do
    let(:volunteer) { FactoryGirl.create(:volunteer) }
    
    it "returns all the jobs of an team that belong to the passed in user" do
      job = FactoryGirl.create(:team_job)
      team = job.workable
      volunteer.jobs << job
      team.jobs_of_user(volunteer).should eq [job]
    end
  end
end

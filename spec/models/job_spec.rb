require 'spec_helper'

describe Job do 
  it { should belong_to :workable }
  it { should belong_to :user }
  it { should validate_presence_of :name }
  it { should have_many :tasks }
  it { should have_many :comments }

  let(:volunteer) { FactoryGirl.create(:volunteer) }
  let(:event) { FactoryGirl.create(:event) }

  it "can tell you if the job has been taken by the user" do 
    job = FactoryGirl.create(:job, :user_id => volunteer.id)
    job.owned_by?(volunteer).should eq true
  end

  it "can tell you whether it has been taken" do
    job = FactoryGirl.create(:job, :user_id => volunteer.id)
    job.taken?.should eq true
  end

  describe '#completed_tasks' do
    it "should return all the complete tasks for a job" do
      job = FactoryGirl.create(:job)
      task1 = FactoryGirl.create(:task, job: job)
      task2 = FactoryGirl.create(:task, job: job, done: true) 
      job.completed_tasks.should eq [task2]
    end
  end

  describe '#incompleted_tasks' do
    it "should return all incomplete tasks for a job" do
      job = FactoryGirl.create(:job)
      task1 = FactoryGirl.create(:task, :job_id => job.id)
      task2 = FactoryGirl.create(:task, :job_id => job.id, :done => true) 
      job.incompleted_tasks.should eq [task1]
    end
  end

  describe '#change_status' do
    it "should change the status between done and not done" do
      job = FactoryGirl.create(:job)
      job.change_status
      job.done.should eq true
    end
    it "should change status back" do 
      job = FactoryGirl.create(:job)
      job.change_status 
      job.change_status
      job.done.should eq false
    end
  end
end

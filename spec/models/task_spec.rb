require 'spec_helper'

describe Task do
  it { should belong_to :job }
  it { should validate_presence_of :description }

  it "should start out as not done" do
    task = FactoryGirl.create(:task)
    task.done.should eq false
  end

  it "list all the completed tasks" do
    task1 = FactoryGirl.create(:task)
    task2 = FactoryGirl.create(:task)
    task1.update(:done => true)
    Task.complete.should eq [task1]
  end

  it "lists all the incomplete tasks" do
    task1 = FactoryGirl.create(:task)
    task2 = FactoryGirl.create(:task)
    task1.update(:done => true)
    Task.incomplete.should eq [task2]
  end
end
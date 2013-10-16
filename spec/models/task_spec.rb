require 'spec_helper'

describe Task do
  it { should belong_to :job }
  it { should validate_presence_of :description }

  it "should start out as not done" do
    task = FactoryGirl.create(:task)
    task.done.should eq false
  end
end
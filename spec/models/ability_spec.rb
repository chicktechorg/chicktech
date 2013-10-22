require 'spec_helper'
require 'cancan/matchers'

describe "Volunteer" do
  describe "abilities" do
    let(:user) { FactoryGirl.create(:volunteer) }
    before { @ability = Ability.new(user) }
    subject { @ability }

    [:create, :destroy].each do |action|
      it { should_not be_able_to(action, Event.new) }
      it { should_not be_able_to(action, User.new) }
      it { should_not be_able_to(action, Job.new) }
      it { should_not be_able_to(action, City.new) }
    end

    [Event.new, User.new, Job.new, City.new].each do |model|
      it { should be_able_to(:read, model) }
    end

    describe "managing tasks" do
      let(:job) { FactoryGirl.create(:job) }
      before do
        user.jobs << job
        @ability = Ability.new(user)
      end
      subject { @ability }
      
      it { should be_able_to(:manage, job.tasks.new) }
      it { should_not be_able_to(:manage, Job.new) }
    end
  end
end

describe "Admin" do
  describe "abilities" do
    let(:admin) { FactoryGirl.create(:admin) }
    before { @ability = Ability.new(admin) }
    subject { @ability }
    
    it { should be_able_to(:manage, Event.new) }
    it { should be_able_to(:manage, Job.new) }
    it { should be_able_to(:manage, City.new) }
    it { should_not be_able_to(:manage, User.new) }
  end
end

describe "Superadmin" do
  describe "abilities" do
    let(:superadmin) { FactoryGirl.create(:superadmin) }
    before { @ability = Ability.new(superadmin) }
    subject { @ability }

    it { should be_able_to(:manage, :all) }
  end
end

describe "unauthorized user" do
  describe "abilities" do
    @user = User.new(role: nil)
    let(:ability) { Ability.new(@user) }
    subject { ability }

    [:create, :read, :update, :destroy].each do |action|
      it { should_not be_able_to(action, Event.new) }
      it { should_not be_able_to(action, Job.new) }
      it { should_not be_able_to(action, User.new) }
      it { should_not be_able_to(action, Task.new) }
      it { should_not be_able_to(action, City.new) }
    end
  end
end

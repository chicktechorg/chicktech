require 'spec_helper'
require 'cancan/matchers'

describe "Abilities" do
subject { Ability.new(user) }

  describe "Volunteer" do

    describe "abilities" do
      let(:user) { FactoryGirl.create(:volunteer) }

      it { should be_able_to(:update, user) }

      [:create, :destroy].each do |action|
        it { should_not be_able_to(action, Event.new) }
        it { should_not be_able_to(action, User.new) }
        it { should_not be_able_to(action, Job.new) }
        it { should_not be_able_to(action, City.new) }
        it { should_not be_able_to(action, Team.new) }
      end

      [Event.new, User.new, Job.new, City.new, Team.new].each do |model|
        it { should be_able_to(:read, model) }
      end

      it { should be_able_to(:update, Job.new) }

      describe "managing tasks" do
        let(:job) { FactoryGirl.create(:job) }
        before { user.jobs << job }

        it { should be_able_to(:manage, job.tasks.new) }
        it { should_not be_able_to(:manage, Job.new) }
      end

      describe "taking the lead" do
        let(:event_with_leader) { FactoryGirl.create(:event) }
        let(:event_without_leader) { FactoryGirl.create(:event_without_leader) }

        it { should_not be_able_to :update, event_without_leader.leadership_role }
        it { should_not be_able_to :update, event_with_leader.leadership_role }
      end

      describe "signing up for a job" do
        let(:job) { FactoryGirl.create(:job) }
        let(:other_user) { FactoryGirl.create(:volunteer) }

        it { should be_able_to :update, Job.new }
        it { should be_able_to :update, Job.new(user: user) }
        it { should_not be_able_to :update, other_user.jobs.new }
      end
    end
  end

  describe "Event leader" do
    describe "abilities" do
      let(:user) { FactoryGirl.create(:volunteer) }
      before { @event = FactoryGirl.create(:event, leadership_role: FactoryGirl.create(:leadership_role, user: user)) }

      it { should be_able_to(:update, @event) }
      it { should be_able_to(:manage, Team.new(event: @event)) }
      it { should be_able_to(:manage, Job.new(workable: @event)) }
      it { should be_able_to(:update, @event.leadership_role) }
    end
  end

  describe "Team leader" do
    describe "abilities" do
      let(:user) { FactoryGirl.create(:volunteer) }
      before do
        @team = FactoryGirl.create(:team)
        user.leadership_roles << @team.leadership_role
      end

      it { should be_able_to(:update, @team) }
      it { should be_able_to(:manage, Job.new(workable: @team)) }
      it { should be_able_to(:update, @team.leadership_role) }
    end
  end

  describe "Admin" do
    describe "abilities" do
      let(:user) { FactoryGirl.create(:admin) }

      it { should be_able_to(:manage, Event.new) }
      it { should be_able_to(:manage, Job.new) }
      it { should be_able_to(:manage, City.new) }
      it { should be_able_to(:manage, LeadershipRole.new) }
      it { should_not be_able_to(:manage, User.new) }
    end
  end

  describe "Superadmin" do
    describe "abilities" do
      let(:user) { FactoryGirl.create(:superadmin) }

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
        it { should_not be_able_to(action, LeadershipRole.new) }
      end
    end
  end
end

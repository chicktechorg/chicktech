require 'spec_helper'
require 'cancan/matchers'

describe "Volunteer" do
  describe "abilities" do
    it "should not be allowed to create an event" do
      user = FactoryGirl.create(:volunteer)
      ability = Ability.new(user)
      ability.should_not be_able_to(:create, Event.new)
    end

    it "should not be allowed to create a user" do
      user = FactoryGirl.create(:volunteer)
      ability = Ability.new(user)
      ability.should_not be_able_to(:create, User.new)
    end
  end
end

describe "Admin" do
  describe "abilities" do
    it "should be able to manage events" do 
      user = FactoryGirl.create(:admin)
      event = FactoryGirl.create(:event)
      ability = Ability.new(user)
      ability.should be_able_to(:manage, event)
    end
  end
end

describe "Superadmin" do
  describe "abilities" do
    it "should be able to manage users" do 
      user = FactoryGirl.create(:superadmin)
      volunteer = FactoryGirl.build(:volunteer)
      ability = Ability.new(user)
      ability.should be_able_to(:manage, volunteer)
    end

    it "should be able to manage events" do
      user = FactoryGirl.create(:superadmin)
      event = FactoryGirl.create(:event)
      ability = Ability.new(user)
      ability.should be_able_to(:manage, event)
    end
  end
end

describe "unauthorized user" do
  describe "abilities" do
    it "should not be allowed to create an event" do
      user = User.new
      ability = Ability.new(user)
      ability.should_not be_able_to(:create, Event.new)
    end

    it "should not be allowed to read an event" do
      user = User.new
      ability = Ability.new(user)
      ability.should_not be_able_to(:view, Event.new)
    end
  end
end

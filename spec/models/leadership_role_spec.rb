require 'spec_helper'

describe LeadershipRole do
  it { should belong_to :user }
  it { should belong_to :leadable }

  describe '#available?' do
    it "should be true if the leadership_role doesn't belong to a user" do
      leadership_role = FactoryGirl.create(:leadership_role, user: nil)
      leadership_role.available?.should be_true
    end

    it "should be false if the leadership_role belongs to a user" do
      leadership_role = FactoryGirl.create(:leadership_role)
      leadership_role.available?.should be_false
    end
  end
end

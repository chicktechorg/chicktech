require 'spec_helper'

describe LeadershipRole do
  it { should belong_to :user }

  # it 'tells you who the user is who is the leader' do
  #   user = FactoryGirl.create(:volunteer)
  #   leadership_role = FactoryGirl.create(:leadership_role, :user_id => user)
  #   leadership_role.user.should eq user
  # end
end

require 'spec_helper'

feature 'Creating Invitations' do
  let(:superadmin) { FactoryGirl.create(:superadmin) }
  let(:user) { FactoryGirl.build(:volunteer) }

  scenario 'user is sent an invitation' do
    sign_in(superadmin)
    visit new_user_invitation_path
    fill_in 'Email', :with => user.email
    click_on 'Send an invitation'
    ActionMailer::Base.deliveries.last.to.should eq [user.email]
  end
end
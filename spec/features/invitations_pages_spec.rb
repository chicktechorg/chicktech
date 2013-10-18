require 'spec_helper'

feature 'Creating Invitations' do
  let(:superadmin) { FactoryGirl.create(:superadmin) }
  let(:user) { FactoryGirl.build(:volunteer) }
  let(:admin) { FactoryGirl.build(:admin) }

  scenario 'user is sent an invitation' do
    sign_in(superadmin)
    visit new_user_invitation_path
    fill_in 'Email', :with => user.email
    click_on 'Send an invitation'
    ActionMailer::Base.deliveries.last.to.should eq [user.email]
  end

  it "generates a unique password_reset_token each time" do
    sign_in(superadmin)
    visit new_user_invitation_path
    fill_in 'Email', :with => user.email
    click_on 'Send an invitation'
    @user1 = User.find_by(:email => user.email)
    last_token = @user1.invitation_token
    visit new_user_invitation_path
    fill_in 'Email', :with => admin.email
    click_on 'Send an invitation'
    @admin1 = User.find_by(:email => admin.email)
    @admin1.invitation_token.should_not eq(last_token)
  end

  it "updates the user password, name, phone and email when token matches " do
    user = FactoryGirl.create(:volunteer, :invitation_token => "something")
    reset_token = user.send_reset_password_instructions
    visit edit_user_password_path(user, reset_password_token: reset_token)
    page.should have_content("password")
  end
end
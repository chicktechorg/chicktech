require 'spec_helper'

feature 'Signing Up' do
  
  scenario 'with valid inputs' do
    user = FactoryGirl.build(:volunteer)
    visit '/users/sign_up'
    fill_in 'First name', :with => user.first_name
    fill_in 'Last name', :with => user.last_name
    fill_in 'Phone', :with => user.phone
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => user.password
    fill_in 'Password confirmation', :with => user.password_confirmation
    select user.role.humanize, :from => 'Role' 
    click_button "Sign up"
    page.should have_content 'successfully'
  end

  scenario "with no inputs" do
    user = FactoryGirl.build(:volunteer)
    visit '/users/sign_up'
    click_button "Sign up" 
    page.should have_content 'blank'
  end

  scenario "with nonmatching password" do
    user = FactoryGirl.build(:volunteer)
    visit '/users/sign_up'
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    fill_in "Password confirmation", :with => "foobar"
    click_button "Sign up" 
    page.should have_content 'match'
  end
end

feature "Signing in" do

  scenario "with correct information" do
    user = FactoryGirl.create(:volunteer)
    visit '/users/sign_in'
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Sign in" 
    page.should have_content 'Signed in as'
  end

  scenario "with incorrect information" do
    user = FactoryGirl.create(:volunteer)
    visit '/users/sign_in'
    fill_in "Email", :with => user.email
    click_button "Sign in" 
    page.should have_content 'Invalid'
  end
end

feature "'Manage Volunteers' link" do
  scenario "Superadmin is signed in" do
    superuser = FactoryGirl.create(:superadmin)
    visit '/users/sign_in'
    fill_in "Email", :with => superuser.email
    fill_in "Password", :with => superuser.password
    click_button "Sign in" 
    page.should have_content 'Manage Volunteers'
  end
  scenario "when Admin is signed in" do
    admin = FactoryGirl.create(:admin)
    visit '/users/sign_in'
    fill_in "Email", :with => admin.email
    fill_in "Password", :with => admin.password
    click_button "Sign in"
    page.should_not have_content 'Manage Volunteers'
  end
  scenario "when no one is signed in" do
    visit root_path
    page.should_not have_content 'Manage Volunteers'
  end
end

feature "'Manage Events' link" do
  scenario "when Admin is signed in" do
    admin = FactoryGirl.create(:admin)
    visit '/users/sign_in'
    fill_in "Email", :with => admin.email
    fill_in "Password", :with => admin.password
    click_button "Sign in"
    page.should have_content 'Manage Events'
  end
  scenario "Superadmin is signed in" do
    superuser = FactoryGirl.create(:superadmin)
    visit '/users/sign_in'
    fill_in "Email", :with => superuser.email
    fill_in "Password", :with => superuser.password
    click_button "Sign in" 
    page.should have_content 'Manage Events'
  end
end






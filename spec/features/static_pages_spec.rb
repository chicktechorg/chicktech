require 'spec_helper'

feature "Static Pages #index redirect" do
  subject { page }

  context "when user is signed in" do
    let(:volunteer) { FactoryGirl.create(:volunteer) }
    before do
      sign_in(volunteer)
      visit root_path
    end

    it { should have_content volunteer.first_name }
  end

  context "when no one is signed in" do
    before { visit root_path }

    it { should_not have_content "Phone:"}
    it { should have_content "ChickTech Volunteer Manager"}
  end
end

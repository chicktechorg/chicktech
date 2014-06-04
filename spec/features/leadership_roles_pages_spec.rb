require 'spec_helper'

feature 'Resigning from leadership role' do
  describe 'resign button' do
    before { @event = FactoryGirl.create(:event) }

    scenario 'available if you are the leader' do
      sign_in(@event.leader)
      visit event_path(@event)
      page.should have_content 'Resign'
    end

    scenario 'available if you are an admin' do
      sign_in(FactoryGirl.create(:admin))
      visit event_path(@event)
      page.should have_content 'Unassign'
    end

    scenario "not available if you don't have permission" do
      sign_in(FactoryGirl.create(:volunteer))
      visit event_path(@event)
      page.should_not have_button 'Resign'
    end

    scenario "clicking removes the leader" do

      sign_in(@event.leader)

      visit event_path(@event)
      click_on 'Resign'
      page.should have_content 'The leader has resigned'
    end
  end
end

# Will test this elswhere
# feature 'Volunteer signs up to be a leader' do
#   let(:volunteer) { FactoryGirl.create(:volunteer) }
#   let(:event_without_leader) { FactoryGirl.create(:event_without_leader) }
#   let(:event) { FactoryGirl.create(:event) }

#   scenario 'successfully' do
#     sign_in(volunteer)
#     visit event_path(event_without_leader)
#     click_on 'Take the lead!'
#     page.should have_content 'Congratulations!'
#   end

#   scenario 'resigns from a job' do
#     sign_in(event.leader)
#     visit event_path(event)
#     click_on 'Resign'
#     page.should have_content 'resigned'
#   end
# end

feature 'open leadership role for others when a leader is deleted' do
  before do
    @volunteer = FactoryGirl.create(:volunteer)
    @other_user = FactoryGirl.create(:volunteer)
    @event = FactoryGirl.create(:event)
    @volunteer.leadership_roles << @event.leadership_role
    sign_in(@other_user)
  end

  scenario 'visiting the event page' do
    @volunteer.destroy
    @event.reload
    visit event_path(@event)
    page.should have_button 'I Would Like To Lead This Event'
  end
end

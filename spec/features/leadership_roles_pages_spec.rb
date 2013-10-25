require 'spec_helper'

feature 'Resigning from leadership role' do
  describe 'resign button' do
    before do
      @volunteer = FactoryGirl.create(:volunteer)
      @event = FactoryGirl.create(:event)
      @leadership_role = FactoryGirl.create(:leadership_role, leadable: @event, user: @volunteer)
    end

    scenario 'available if you are the leader' do
      sign_in(@volunteer)
      visit event_path(@event)
      page.should have_content 'Resign'
    end

    scenario 'available if you are an admin' do
      sign_in(FactoryGirl.create(:admin))
      visit event_path(@event)
      page.should have_content 'Resign'
    end

    scenario "not available if you don't have permission" do
      sign_in(FactoryGirl.create(:volunteer))
      visit event_path(@event)
      page.should_not have_content 'Resign'
    end

    scenario "clicking removes the leader" do
      sign_in(@volunteer)
      visit event_path(@event)
      click_on 'Resign'
      page.should have_content 'leader has resigned.'
    end
  end
end

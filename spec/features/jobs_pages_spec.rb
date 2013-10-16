require 'spec_helper'

feature 'Creating jobs' do

  scenario 'with valid inputs' do
    event = FactoryGirl.create(:event)
    visit new_job_path
    fill_in 'Name', with: 'Example name'
    select event.name, from: 'job_event_id'
    click_on 'Create Job'
    page.should have_content 'successfully'
  end

  scenario 'with no inputs' do
    event = FactoryGirl.build(:event)
    visit new_job_path
    click_on 'Create Job' 
    page.should have_content 'blank'
  end
end

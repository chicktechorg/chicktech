require 'spec_helper'

feature 'Creating jobs' do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:event) { FactoryGirl.create(:event) }

  scenario 'with valid inputs' do
    event = FactoryGirl.create(:event)
    sign_in(admin)
    visit new_job_path
    fill_in 'Name', with: 'Example name'
    select event.name, from: 'job_event_id'
    click_on 'Create Job'
    page.should have_content 'successfully'
  end

  scenario 'with no inputs' do
    sign_in(admin)
    visit new_job_path
    click_on 'Create Job' 
    page.should have_content 'blank'
  end
end

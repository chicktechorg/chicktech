require 'spec_helper'

feature 'Creating jobs' do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:event) { FactoryGirl.create(:event) }

  scenario 'with valid inputs' do
    sign_in(admin)
    event = FactoryGirl.create(:event)
    visit event_path(event)
    click_on 'Add jobs'
    fill_in 'Name', with: 'Example name'
    click_on 'Create Job'
    page.should have_content 'successfully'
  end

  scenario 'with no inputs' do
    sign_in(admin)
    event = FactoryGirl.create(:event)
    visit event_path(event)
    click_on 'Add jobs'
    click_on 'Create Job' 
    page.should have_content 'blank'
  end
end

feature 'User signs up for a job' do
  let(:volunteer) { FactoryGirl.create(:volunteer) }
  let(:job) { FactoryGirl.create(:job)}
  before { sign_in(volunteer) }

  scenario 'successfully' do
    visit event_path(job.workable)
    click_on 'Sign Up!'
    page.should have_content 'Congratulations!'
  end

  scenario 'resigns from a job' do
    volunteer.jobs << job
    visit event_path(job.workable)
    click_on 'Resign'
    page.should have_content 'resigned'
  end
end

feature 'Admin or leader can remove a user from a job' do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:volunteer) { FactoryGirl.create(:volunteer) }
  let(:job) { FactoryGirl.create(:job, :user => volunteer)}
  before { sign_in(admin) }

  scenario 'successfully' do
    visit job_path(job)
    page.should have_content "Unassign"
  end
end

feature 'Admin deletes a job' do
  let(:superadmin) { FactoryGirl.create(:superadmin) }
  let(:job) { FactoryGirl.create(:job) }
  before { sign_in(superadmin) }

  scenario 'successfully' do
    visit job_path(job)
    click_on 'Delete'
    page.should have_content "'#{job.name}' deleted."
  end
end

feature 'Comment on a job' do
  let(:volunteer) { FactoryGirl.create(:volunteer) }
  let(:job) { FactoryGirl.create(:job)}
  before { sign_in(volunteer) }

  scenario 'successfully' do
    visit job_path(job)
    fill_in 'Add a comment', with: 'Stuff'
    click_on 'Comment'
    page.should have_content 'created'
  end

  scenario 'unsuccessfully' do
    visit job_path(job)
    click_on 'Comment'
    page.should have_content 'blank'
  end
end

feature 'Add a due date to jobs' do
  let(:volunteer) { FactoryGirl.create(:volunteer) }
  let(:job) { FactoryGirl.create(:job)}
  before { sign_in(volunteer) }

  scenario 'edit job' do
    visit edit_job_path(job)
    fill_in 'Due date', with: '28 November 2013 - 10:50 AM'
    click_on 'Update Job'
    page.should have_content 'updated'
  end
end

feature 'marking a job as done' do
  let(:volunteer) { FactoryGirl.create(:volunteer) }
  let(:job) { FactoryGirl.create(:job, user: volunteer, due_date: (Time.now + 2.days)) }
  before { sign_in(volunteer) }

  scenario 'visiting the job page' do
    visit job_path(job)
    save_and_open_page
    page.should have_content 'This job is not complete.'
  end
end

feature 'open up jobs for other from deleted user' do
  before do
    @volunteer = FactoryGirl.create(:volunteer)
    @other_user = FactoryGirl.create(:volunteer)
    @job = FactoryGirl.create(:job, user: @volunteer)
    sign_in(@other_user)
  end

  scenario 'visiting the job page' do
    @volunteer.destroy
    @job.reload
    visit job_path(@job)
    page.should have_button 'Sign Up!'
  end
end






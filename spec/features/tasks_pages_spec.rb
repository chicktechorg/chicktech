require 'spec_helper'

feature "Creating tasks" do
  scenario "with input from volunteer" do
    volunteer = FactoryGirl.create(:volunteer)
    event = FactoryGirl.create(:event)
    job = FactoryGirl.create(:job, :event_id => event.id)
    sign_in(volunteer)
    visit job_path(job)
    fill_in 'Description', with: 'Example task description'
    click_on 'Create Task'
    find('#not-done-task-list').should have_content('Example task description')
  end
end

feature 'Removing tasks' do
  scenario 'by clicking a remove link' do
    volunteer = FactoryGirl.create(:volunteer)
    job = FactoryGirl.create(:job)
    task = FactoryGirl.create(:task, :job_id => job.id)
    sign_in(volunteer)
    visit job_path(job)
    click_link '(remove)'
    page.should_not have_content task.description
  end
end

feature 'Clicking on a task' do
  scenario 'Moving from not done to done', js: true do
    volunteer = FactoryGirl.create(:volunteer)
    job = FactoryGirl.create(:job)
    task = FactoryGirl.create(:task, :job_id => job.id)
    sign_in(volunteer)
    visit job_path(job)
    check task.description
    find('#done-task-list').should have_content(task.description)
  end


  scenario 'moving from done to not done', js: true do
    volunteer = FactoryGirl.create(:volunteer)
    job = FactoryGirl.create(:job)
    task = FactoryGirl.create(:task, :job_id => job.id)
    sign_in(volunteer)
    visit job_path(job)
    check task.description
    uncheck task.description
    find('#not-done-task-list').should have_content(task.description)
  end
end
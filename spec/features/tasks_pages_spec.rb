require 'spec_helper'

feature "Creating tasks" do
  scenario "with input from volunteer" do
    volunteer = FactoryGirl.create(:volunteer)
    job = FactoryGirl.create(:job)
    sign_in(volunteer)
    visit event_path(job.workable)
    click_on 'Add Task'
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
    visit event_path(job.workable)
    click_link 'X'
    page.should_not have_content task.description
  end
end

feature 'Clicking on a task' do
  scenario 'Moving from not done to done', js: true do
    volunteer = FactoryGirl.create(:volunteer)
    job = FactoryGirl.create(:job)
    task = FactoryGirl.create(:task, :job_id => job.id)
    sign_in(volunteer)
    visit event_path(job.workable)
    check task.description
    find('#done-task-list').should have_content(task.description)
  end


  scenario 'moving from done to not done', js: true do
    volunteer = FactoryGirl.create(:volunteer)
    job = FactoryGirl.create(:job)
    task = FactoryGirl.create(:task, :job_id => job.id)
    sign_in(volunteer)
    visit event_path(job.workable)
    check task.description
    uncheck task.description
    find('#not-done-task-list').should have_content(task.description)
  end
end

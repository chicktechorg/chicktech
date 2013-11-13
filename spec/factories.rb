require 'spec_helper'

FactoryGirl.define do

  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    description 'Example event description'
    start Time.now + 1.hour
    finish Time.now + 4.hours
    leadership_role
  end

  factory :event_without_leader, class: Event do
    sequence(:name) { |n| "Event #{n}" }
    description 'Example event description'
    start Time.now + 1.hour
    finish Time.now + 4.hours
    association :leadership_role, factory: :open_leadership_role
  end

  factory :team do
    name 'Logistics'
    event
    association :leadership_role, factory: :open_leadership_role

    factory :team_with_leader do
      leadership_role
    end
  end

  factory :leadership_role do
    name 'Project Manager'
    association :user, factory: :volunteer
  end

  factory :open_leadership_role, class: LeadershipRole do
    name 'Coordinator'
  end

  factory :job do
    sequence(:name) { |n| "The Chosen One #{n}" }
    description 'Save Hogwarts'
    association :workable, factory: :event
  
    factory :team_job do
      association :workable, factory: :team
    end  
  end

  factory :task do
    description 'Example task'
    job
  end
  
  factory :city do
    name 'Portland, OR'
  end

  factory :volunteer, class: User do
    first_name 'Harry'
    last_name 'Potter'
    phone '5555555555'
    sequence(:email) { |n| "#{n}@hogwarts.edu" }
    role 'volunteer'
    password 'voldemort'
    password_confirmation 'voldemort'
    
    factory :admin do
      first_name 'Severus'
      email 'severus@hogwarts.edu'
      role 'admin'
      password 'voldemort'
      password_confirmation 'voldemort'
    end

    factory :superadmin do
      first_name 'Albus'
      last_name 'Dumbledore'
      email 'graybeard@hogwarts.edu'
      role 'superadmin'
    end
  end
end

require 'spec_helper'

FactoryGirl.define do

  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    description 'Example event description'
    start Time.now + 1.hour
    finish Time.now + 4.hours
  end

  factory :task do
    description 'Example task'
    sequence(:job_id) { |n| n.to_i }
  end

  factory :volunteer, class: User do
    first_name 'Harry'
    last_name 'Potter'
    phone '5555555555'
    email 'harry@hogwarts.edu'
    role 'volunteer'
    password 'voldemort'
    password_confirmation 'voldemort'
  end

  factory :admin, class: User do
    first_name 'Severus'
    last_name 'Snape'
    phone '5555555555'
    email 'potionsforlife@hogwarts.edu'
    role 'admin'
    password 'voldemort'
    password_confirmation 'voldemort'
  end

  factory :superadmin, class: User do
    first_name 'Albus'
    last_name 'Dumbledore'
    phone '5555555555'
    email 'graybeard@hogwarts.edu'
    role 'superadmin'
    password 'voldemort'
    password_confirmation 'voldemort'
  end
end

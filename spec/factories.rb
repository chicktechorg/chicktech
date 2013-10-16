require 'spec_helper'

FactoryGirl.define do

  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    description 'Example event description'
    start Time.now + 1.hour
    finish Time.now + 4.hours
  end

  factory :user do
    first_name 'Harry'
    last_name 'Potter'
    phone '5555555555'
    email 'harry@hogwarts.edu'
    role 'volunteer'
    password 'voldemort'
    password_confirmation 'voldemort'
  end

  factory :task do
    description 'Example task'
    sequence(:job_id) { |n| n.to_i }
  end
end

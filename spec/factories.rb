require 'spec_helper'

FactoryGirl.define do
  factory :user do
    first_name 'Harry'
    last_name 'Potter'
    phone '5555555555'
    email 'harry@hogwarts.edu'
    role 'volunteer'
    password 'voldemort'
    password_confirmation 'voldemort'
  end
end
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
    event
    job
    #fixme create more associations like this
  end

  factory :volunteer, class: User do
    first_name 'Harry'
    last_name 'Potter'
    phone '5555555555'
    email 'harry@hogwarts.edu'
    role 'volunteer'
    password 'voldemort'
    password_confirmation 'voldemort'
    
    factory :admin do
      first_name 'Admin' #fixme
      role 'admin'
    end

    factory :superadmin do
      role 'superadmin'
    end
  end

  # factory :volunteer, class: User do
  #   first_name 'Harry'
  #   last_name 'Potter'
  #   phone '5555555555'
  #   email 'harry@hogwarts.edu'
  #   role 'volunteer'
  #   password 'voldemort'
  #   password_confirmation 'voldemort'
  # end

  # factory :admin, class: User do
  #   first_name 'Severus'
  #   last_name 'Snape'
  #   phone '5555555555'
  #   email 'potionsforlife@hogwarts.edu'
  #   role 'admin'
  #   password 'voldemort'
  #   password_confirmation 'voldemort'
  # end

  # factory :superadmin, class: User do
  #   first_name 'Albus'
  #   last_name 'Dumbledore'
  #   phone '5555555555'
  #   email 'graybeard@hogwarts.edu'
  #   role 'superadmin'
  #   password 'voldemort'
  #   password_confirmation 'voldemort'
  # end

  factory :job do
    name 'The Chosen One'
    description 'Save Hogwarts'
  end
end

FactoryGirl.define do

  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    description 'Example event description'
    start Time.now + 1.hour
    finish Time.now + 4.hours
  end
end
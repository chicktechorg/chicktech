require 'spec_helper'

describe Job do 
  it { should belong_to :event }
  it { should belong_to :user }
  it { should validate_presence_of :name }
  it { should validate_presence_of :event_id }
end
require 'spec_helper'

describe Team do
  it { should validate_presence_of :name }
  it { should have_many :jobs }
  it { should belong_to :event }
end

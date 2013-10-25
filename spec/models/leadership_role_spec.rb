require 'spec_helper'

describe LeadershipRole do
  it { should belong_to :user }
  it { should belong_to :leadable }
end

require 'spec_helper'

describe Template do
  describe ".all" do
    it 'returns all events that are flagged as templates' do
      template = FactoryGirl.create(:template)
      event = FactoryGirl.create(:event)
      Template.all.any? { |temp| temp.name == template.name }.should be_true
      Template.all.any? { |temp| temp.name == event.name }.should be_false
    end
  end

  describe '.new' do
    it 'creates a template off an existing event' do
      event = FactoryGirl.create(:event)
      template = Template.new({event: event})
      template.save
      Template.all.first.should eq template
    end
  end
end

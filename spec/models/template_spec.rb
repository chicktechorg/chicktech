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

  describe '#create_event_from_template' do
    it 'creates an event off an existing template' do
      template = FactoryGirl.create(:template)
      event = template.create_event_from_template
      Event.all.count.should eq 1
    end
  end
end



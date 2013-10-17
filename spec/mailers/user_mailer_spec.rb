require "spec_helper"

describe UserMailer do
  describe 'welcome_email' do
    let(:user) { FactoryGirl.create(:volunteer) }
    let(:mail) { UserMailer.welcome_email(user) }

    it 'renders the subject' do
      mail.subject.should eq 'Welcome to Chicktech'
    end

    it 'renders the receiver email' do
      mail.to.should eq [user.email]
    end

    it 'renders the sender email' do
      mail.from.should eq ['noreply@chicktech.org']
    end

    it 'renders the user name' do
      mail.body.encoded.should have_content(user.first_name)
    end
  end
end

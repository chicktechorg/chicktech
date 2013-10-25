require "spec_helper"

describe UserMailer do
  describe 'send_information' do
    let(:user) { FactoryGirl.create(:volunteer) }
    let(:mail) { UserMailer.send_information(user) }

    it 'renders the subject' do
      mail.subject.should eq 'ChickTech Updates'
    end

    it 'renders the receiver email' do
      mail.to.should eq [user.email]
    end

    it 'renders the sender email' do
      mail.from.should eq ['noreply@chicktech.herokuapp.com']
    end

    it 'renders the user name' do
      mail.body.encoded.should have_content(user.first_name)
    end
  end
end

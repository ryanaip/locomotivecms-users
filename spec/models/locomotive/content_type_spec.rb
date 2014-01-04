require 'spec_helper'

describe Locomotive::ContentType do
  subject { FactoryGirl.build(:content_type) }

  describe '.user' do
    it 'can be set' do
      subject._user = true
      subject._user.should == true
    end

    it 'defaults to false' do
      subject._user.should == false
    end
  end

  describe 'validation' do
    it 'requires an email field to be present' do
      pending
    end
  end
end

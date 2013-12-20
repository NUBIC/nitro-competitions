require 'spec_helper'

describe Reviewer do

  it { should belong_to(:user) }
  it { should belong_to(:program) }

  it 'can be instantiated' do
    FactoryGirl.build(:reviewer).should be_an_instance_of(Reviewer)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:reviewer).should be_persisted
  end
end

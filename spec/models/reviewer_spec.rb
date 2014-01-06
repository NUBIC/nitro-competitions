require 'spec_helper'

describe Reviewer do

  it { should belong_to(:user) }
  it { should belong_to(:program) }

  it 'can be instantiated' do
    FactoryGirl.build(:reviewer).should be_an_instance_of(Reviewer)
  end

  let(:reviewer) { FactoryGirl.create(:reviewer) }

  it 'can be saved successfully' do
    reviewer.should be_persisted
  end

  it 'has program' do
    reviewer.program.should_not be_nil
  end

  it 'has user' do
    reviewer.user.should_not be_nil
  end

end

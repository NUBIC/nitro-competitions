require 'spec_helper'

describe Right do

  it { should have_and_belong_to_many(:roles) }

  it 'can be instantiated' do
    FactoryGirl.build(:right).should be_an_instance_of(Right)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:right).should be_persisted
  end
end

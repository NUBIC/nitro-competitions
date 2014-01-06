require 'spec_helper'

describe Role do

  it 'can be instantiated' do
    FactoryGirl.build(:role).should be_an_instance_of(Role)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:role).should be_persisted
  end
end

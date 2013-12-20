require 'spec_helper'

describe KeyPerson do

  it { should belong_to(:submission) }
  it { should belong_to(:user) }

  it 'can be instantiated' do
    FactoryGirl.build(:key_person).should be_an_instance_of(KeyPerson)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:key_person).should be_persisted
  end

end

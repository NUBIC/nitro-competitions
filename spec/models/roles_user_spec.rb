require 'spec_helper'

describe RolesUser do

  it { should belong_to(:program) }
  it { should belong_to(:user) }
  it { should belong_to(:role) }
  it { should have_many(:rights).through(:role) }

  it 'can be instantiated' do
    FactoryGirl.build(:roles_user).should be_an_instance_of(RolesUser)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:roles_user).should be_persisted
  end
end
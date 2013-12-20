require 'spec_helper'

describe Program do

  it { should have_many(:roles_users) }
  it { should have_many(:admins).through(:roles_users) }
  it { should have_many(:projects) }
  it { should have_many(:reviewers) }
  it { should have_many(:logs) }
  it { should belong_to(:creater) }

  it 'can be instantiated' do
    FactoryGirl.build(:program).should be_an_instance_of(Program)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:program).should be_persisted
  end
end

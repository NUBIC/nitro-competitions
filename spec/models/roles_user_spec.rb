# -*- coding: utf-8 -*-

describe RolesUser, :type => :model do

  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:role) }
  it { is_expected.to have_many(:rights).through(:role) }

  it 'can be instantiated' do
    expect(FactoryBot.build(:roles_user)).to be_an_instance_of(RolesUser)
  end

  let(:ru) { FactoryBot.create(:roles_user) }

  it 'can be saved successfully' do
    expect(ru).to be_persisted
  end

  it 'has role' do
    expect(ru.role).not_to be_nil
  end

  it 'has user' do
    expect(ru.user).not_to be_nil
  end
end

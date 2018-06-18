# -*- coding: utf-8 -*-

describe Log, :type => :model do

  it { is_expected.to belong_to(:project) }
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:user) }

  it 'can be instantiated' do
    expect(FactoryBot.build(:log)).to be_an_instance_of(Log)
  end

  it 'can be saved successfully' do
    expect(FactoryBot.create(:log)).to be_persisted
  end

end

# -*- coding: utf-8 -*-

describe Right, :type => :model do

  it { is_expected.to have_and_belong_to_many(:roles) }

  it 'can be instantiated' do
    expect(FactoryBot.build(:right)).to be_an_instance_of(Right)
  end

  it 'can be saved successfully' do
    expect(FactoryBot.create(:right)).to be_persisted
  end
end

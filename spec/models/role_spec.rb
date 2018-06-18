# -*- coding: utf-8 -*-

describe Role, :type => :model do

  it 'can be instantiated' do
    expect(FactoryBot.build(:role)).to be_an_instance_of(Role)
  end

  it 'can be saved successfully' do
    expect(FactoryBot.create(:role)).to be_persisted
  end
end

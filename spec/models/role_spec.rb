# -*- coding: utf-8 -*-
require 'spec_helper'

describe Role, :type => :model do

  it 'can be instantiated' do
    expect(FactoryGirl.build(:role)).to be_an_instance_of(Role)
  end

  it 'can be saved successfully' do
    expect(FactoryGirl.create(:role)).to be_persisted
  end
end

# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: rights
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  controller :string(255)
#  action     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Right, :type => :model do

  it { is_expected.to have_and_belong_to_many(:roles) }

  it 'can be instantiated' do
    expect(FactoryGirl.build(:right)).to be_an_instance_of(Right)
  end

  it 'can be saved successfully' do
    expect(FactoryGirl.create(:right)).to be_persisted
  end
end

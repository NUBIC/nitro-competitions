# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20140213161624
#
# Table name: rights
#
#  action     :string(255)
#  controller :string(255)
#  created_at :datetime
#  id         :integer          not null, primary key
#  name       :string(255)
#  updated_at :datetime
#

require 'spec_helper'

describe Right do

  it { should have_and_belong_to_many(:roles) }

  it 'can be instantiated' do
    FactoryGirl.build(:right).should be_an_instance_of(Right)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:right).should be_persisted
  end
end

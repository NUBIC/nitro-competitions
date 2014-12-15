# -*- coding: utf-8 -*-
require 'spec_helper'

describe KeyPerson, :type => :model do

  it { is_expected.to belong_to(:submission) }
  it { is_expected.to belong_to(:user) }

  it 'can be instantiated' do
    expect(FactoryGirl.build(:key_person)).to be_an_instance_of(KeyPerson)
  end

  it 'can be saved successfully' do
    expect(FactoryGirl.create(:key_person)).to be_persisted
  end

end

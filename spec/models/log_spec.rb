# -*- coding: utf-8 -*-
require 'spec_helper'

describe Log do

  it { should belong_to(:project) }
  it { should belong_to(:program) }
  it { should belong_to(:user) }

  it 'can be instantiated' do
    FactoryGirl.build(:log).should be_an_instance_of(Log)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:log).should be_persisted
  end

end

# -*- coding: utf-8 -*-
require 'spec_helper'

describe Program, :type => :model do

  it { is_expected.to have_many(:roles_users) }
  it { is_expected.to have_many(:admins).through(:roles_users) }
  it { is_expected.to have_many(:projects) }
  it { is_expected.to have_many(:reviewers) }
  it { is_expected.to have_many(:logs) }
  it { is_expected.to belong_to(:creater) }

  it 'can be instantiated' do
    expect(FactoryGirl.build(:program)).to be_an_instance_of(Program)
  end

  it 'can be saved successfully' do
    expect(FactoryGirl.create(:program)).to be_persisted
  end
end

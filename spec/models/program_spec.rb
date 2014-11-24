# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20141124223129
#
# Table name: programs
#
#  created_at    :datetime
#  created_id    :integer
#  created_ip    :string(255)
#  deleted_at    :datetime
#  deleted_id    :integer
#  deleted_ip    :string(255)
#  email         :string(255)
#  id            :integer          not null, primary key
#  program_name  :string(255)
#  program_title :string(255)
#  program_url   :string(255)
#  updated_at    :datetime
#  updated_id    :integer
#  updated_ip    :string(255)
#

require 'spec_helper'

describe Program do

  it { should have_many(:roles_users) }
  it { should have_many(:admins).through(:roles_users) }
  it { should have_many(:projects) }
  it { should have_many(:reviewers) }
  it { should have_many(:logs) }
  it { should belong_to(:creater) }

  it 'can be instantiated' do
    FactoryGirl.build(:program).should be_an_instance_of(Program)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:program).should be_persisted
  end
end

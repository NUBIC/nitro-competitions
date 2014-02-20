# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20140213161624
#
# Table name: roles_users
#
#  created_at :datetime
#  created_id :integer
#  created_ip :string(255)
#  deleted_at :datetime
#  deleted_id :integer
#  deleted_ip :string(255)
#  id         :integer          not null, primary key
#  program_id :integer
#  role_id    :integer
#  updated_at :datetime
#  updated_id :integer
#  updated_ip :string(255)
#  user_id    :integer
#

require 'spec_helper'

describe RolesUser do

  it { should belong_to(:program) }
  it { should belong_to(:user) }
  it { should belong_to(:role) }
  it { should have_many(:rights).through(:role) }

  it 'can be instantiated' do
    FactoryGirl.build(:roles_user).should be_an_instance_of(RolesUser)
  end

  let(:ru) { FactoryGirl.create(:roles_user) }

  it 'can be saved successfully' do
    ru.should be_persisted
  end

  it 'has role' do
    ru.role.should_not be_nil
  end

  it 'has user' do
    ru.user.should_not be_nil
  end
end

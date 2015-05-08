# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: roles_users
#
#  id         :integer          not null, primary key
#  role_id    :integer
#  user_id    :integer
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  created_id :integer
#  created_ip :string(255)
#  updated_id :integer
#  updated_ip :string(255)
#  deleted_at :datetime
#  deleted_id :integer
#  deleted_ip :string(255)
#

require 'spec_helper'

describe RolesUser, :type => :model do

  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:role) }
  it { is_expected.to have_many(:rights).through(:role) }

  it 'can be instantiated' do
    expect(FactoryGirl.build(:roles_user)).to be_an_instance_of(RolesUser)
  end

  let(:ru) { FactoryGirl.create(:roles_user) }

  it 'can be saved successfully' do
    expect(ru).to be_persisted
  end

  it 'has role' do
    expect(ru.role).not_to be_nil
  end

  it 'has user' do
    expect(ru.user).not_to be_nil
  end
end

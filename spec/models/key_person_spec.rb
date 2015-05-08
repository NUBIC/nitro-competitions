# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: key_personnel
#
#  id            :integer          not null, primary key
#  submission_id :integer
#  user_id       :integer
#  role          :string(255)
#  username      :string(255)
#  first_name    :string(255)
#  last_name     :string(255)
#  email         :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe KeyPerson, :type => :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:submission) }

  context '#valid?' do
    it { is_expected.to validate_presence_of :role }
    it { is_expected.to validate_presence_of :username }
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
  end

  context '#name normalization' do
    subject { KeyPerson.new(first_name: '   Name is combined with a space', last_name: 'and whitespace removed    ').name }
    it { is_expected.to eq("Name is combined with a space and whitespace removed") }
  end

  context '#sort_name' do
    subject { KeyPerson.new(first_name: 'First', last_name: 'Last').sort_name }
    it { is_expected.to eq('Last, First') }
  end
end

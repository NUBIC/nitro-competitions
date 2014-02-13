# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20140213161624
#
# Table name: key_personnel
#
#  created_at    :datetime
#  email         :string(255)
#  first_name    :string(255)
#  id            :integer          not null, primary key
#  last_name     :string(255)
#  role          :string(255)
#  submission_id :integer
#  updated_at    :datetime
#  user_id       :integer
#  username      :string(255)
#

require 'spec_helper'

describe KeyPerson do

  it { should belong_to(:submission) }
  it { should belong_to(:user) }

  it 'can be instantiated' do
    FactoryGirl.build(:key_person).should be_an_instance_of(KeyPerson)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:key_person).should be_persisted
  end

end

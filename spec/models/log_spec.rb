# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20140213161624
#
# Table name: logs
#
#  action_name     :string(255)
#  activity        :string(255)
#  controller_name :string(255)
#  created_at      :datetime
#  created_ip      :string(255)
#  id              :integer          not null, primary key
#  params          :text
#  program_id      :integer
#  project_id      :integer
#  updated_at      :datetime
#  user_id         :integer
#

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

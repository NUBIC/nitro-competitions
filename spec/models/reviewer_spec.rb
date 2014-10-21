# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20140908190758
#
# Table name: reviewers
#
#  created_at :datetime         not null
#  created_id :integer
#  created_ip :string(255)
#  deleted_at :datetime
#  deleted_id :integer
#  deleted_ip :string(255)
#  id         :integer          not null, primary key
#  program_id :integer
#  updated_at :datetime         not null
#  updated_id :integer
#  updated_ip :string(255)
#  user_id    :integer
#

require 'spec_helper'

describe Reviewer do

  it { should belong_to(:user) }
  it { should belong_to(:program) }

  it 'can be instantiated' do
    FactoryGirl.build(:reviewer).should be_an_instance_of(Reviewer)
  end

  let(:reviewer) { FactoryGirl.create(:reviewer) }

  it 'can be saved successfully' do
    reviewer.should be_persisted
  end

  it 'has program' do
    reviewer.program.should_not be_nil
  end

  it 'has user' do
    reviewer.user.should_not be_nil
  end

end

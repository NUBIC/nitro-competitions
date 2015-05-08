# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: reviewers
#
#  id         :integer          not null, primary key
#  program_id :integer
#  user_id    :integer
#  created_id :integer
#  created_ip :string(255)
#  updated_id :integer
#  updated_ip :string(255)
#  deleted_at :datetime
#  deleted_id :integer
#  deleted_ip :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Reviewer, :type => :model do

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:program) }

  it 'can be instantiated' do
    expect(FactoryGirl.build(:reviewer)).to be_an_instance_of(Reviewer)
  end

  let(:reviewer) { FactoryGirl.create(:reviewer) }

  it 'can be saved successfully' do
    expect(reviewer).to be_persisted
  end

  it 'has program' do
    expect(reviewer.program).not_to be_nil
  end

  it 'has user' do
    expect(reviewer.user).not_to be_nil
  end

end

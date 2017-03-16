# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: logs
#
#  id              :integer          not null, primary key
#  activity        :string(255)
#  user_id         :integer
#  program_id      :integer
#  project_id      :integer
#  controller_name :string(255)
#  action_name     :string(255)
#  params          :text
#  created_ip      :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

describe Log, :type => :model do

  it { is_expected.to belong_to(:project) }
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:user) }

  it 'can be instantiated' do
    expect(FactoryGirl.build(:log)).to be_an_instance_of(Log)
  end

  it 'can be saved successfully' do
    expect(FactoryGirl.create(:log)).to be_persisted
  end

end

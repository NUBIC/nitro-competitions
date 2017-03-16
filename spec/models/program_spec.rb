# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: programs
#
#  id                          :integer          not null, primary key
#  program_name                :string(255)
#  program_title               :string(255)
#  program_url                 :string(255)
#  created_id                  :integer
#  created_ip                  :string(255)
#  updated_id                  :integer
#  updated_ip                  :string(255)
#  deleted_at                  :datetime
#  deleted_id                  :integer
#  deleted_ip                  :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  email                       :string(255)
#  allow_reviewer_notification :boolean          default(TRUE)
#

describe Program, :type => :model do
  it { is_expected.to have_many(:roles_users) }
  it { is_expected.to have_many(:projects) }
  it { is_expected.to have_many(:reviewers) }
  it { is_expected.to have_many(:logs) }
  it { is_expected.to belong_to(:creator) }

  it 'can be instantiated' do
    expect(FactoryGirl.build(:program)).to be_an_instance_of(Program)
  end

  it 'can be saved successfully' do
    expect(FactoryGirl.create(:program)).to be_persisted
  end

  context ".admins" do
    it 'returns the administrators associated with the program' do
      # no admins returns blank
      program = FactoryGirl.create(:program)
      expect(program.admins).to be_blank
      # create a RoleUser with Admin role
      role    = FactoryGirl.create(:role, name: 'Admin')
      admin   = FactoryGirl.create(:user)
      FactoryGirl.create(:roles_user, program: program, role: role, user: admin)
      expect(program.admins).to eq([admin])
    end
  end

  context ".submission_notifiable_admins" do
    it 'returns the administrators associated with the program who should receive submission notifications' do
      # no admins returns blank
      program = FactoryGirl.create(:program)
      expect(program.submission_notifiable_admins).to be_blank
      # create a RoleUser with Admin role
      role    = FactoryGirl.create(:role, name: 'Admin')
      admin1  = FactoryGirl.create(:user, should_receive_submission_notifications: true)
      admin2  = FactoryGirl.create(:user, should_receive_submission_notifications: false)
      FactoryGirl.create(:roles_user, program: program, role: role, user: admin1)
      FactoryGirl.create(:roles_user, program: program, role: role, user: admin2)
      expect(program.admins).to eq([admin1, admin2])
      expect(program.submission_notifiable_admins).to eq([admin1])
    end
  end

  context '#valid?' do
    context '#program_name' do
      it { is_expected.to validate_presence_of(:program_name) }
      it { is_expected.to validate_uniqueness_of(:program_name) }
      it { is_expected.to validate_length_of(:program_name).is_at_least(2) }
      it { is_expected.to validate_length_of(:program_name).is_at_most(20) }

      it { is_expected.to allow_value('LETTERS_0123').for(:program_name) }

      it 'leaves a blank name blank' do
        p = Program.new
        p.valid?

        expect(p.program_name).to eq(nil)
      end

      it 'only allow alphanumeric characters, and replace spaces with underscores' do
        p = Program.new(program_name: ' Whitespace, c0mma.')
        p.valid?

        expect(p.program_name).to eq('Whitespace_c0mma_')
      end
    end

    context '#program_title' do
      it { is_expected.to validate_presence_of(:program_title) }
      it { is_expected.to validate_length_of(:program_title).is_at_least(2) }
      it { is_expected.to validate_length_of(:program_title).is_at_most(80) }
    end

    it { is_expected.to validate_presence_of(:program_url) }
  end
end

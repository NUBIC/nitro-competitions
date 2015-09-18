# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  username              :string(255)      not null
#  era_commons_name      :string(255)
#  first_name            :string(255)      not null
#  last_name             :string(255)      not null
#  middle_name           :string(255)
#  email                 :string(255)
#  degrees               :string(255)
#  name_suffix           :string(255)
#  business_phone        :string(255)
#  fax                   :string(255)
#  title                 :string(255)
#  employee_id           :integer
#  primary_department    :string(255)
#  campus                :string(255)
#  campus_address        :text
#  address               :text
#  city                  :string(255)
#  postal_code           :string(255)
#  state                 :string(255)
#  country               :string(255)
#  photo_content_type    :string(255)
#  photo_file_name       :string(255)
#  photo                 :binary
#  biosketch_document_id :integer
#  first_login_at        :datetime
#  last_login_at         :datetime
#  password_salt         :string(255)
#  password_hash         :string(255)
#  password_changed_at   :datetime
#  password_changed_id   :integer
#  password_changed_ip   :string(255)
#  created_id            :integer
#  created_ip            :string(255)
#  updated_id            :integer
#  updated_ip            :string(255)
#  deleted_at            :datetime
#  deleted_id            :integer
#  deleted_ip            :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'spec_helper'

describe User, :type => :model do

  it { is_expected.to have_many(:reviewers) }
  it { is_expected.to have_many(:key_personnel) }
  it { is_expected.to have_many(:submission_reviews) }
  it { is_expected.to have_many(:reviewed_submissions) }
  it { is_expected.to have_many(:roles_users) }
  it { is_expected.to have_many(:roles).through(:roles_users) }
  it { is_expected.to have_many(:logs) }
  it { is_expected.to have_many(:submissions) }
  it { is_expected.to have_many(:proxy_submissions) }

  it { is_expected.to belong_to(:biosketch) }

  it 'can be instantiated' do
    expect(FactoryGirl.build(:user)).to be_an_instance_of(User)
  end

  it 'can be saved successfully' do
    expect(FactoryGirl.create(:user)).to be_persisted
  end

  context 'user validations' do
    let(:user) { User.new }
    describe 'with validations set to true' do
      before do
        user.validate_email_attr = true
        user.validate_era_commons_name = true
      end
      it 'is not valid' do
        expect(user).not_to be_nil
        expect(user).not_to be_valid
        [:username, :first_name, :last_name, :email, :era_commons_name].each do |att|
          expect(user.errors).to include(att)
        end
      end
    end
    describe 'with validations set to false' do
      before do
        user.validate_era_commons_name = false
      end
      it 'attributes are not included in errors' do
        expect(user).not_to be_nil
        expect(user).not_to be_valid
        [:era_commons_name].each do |att|
          expect(user.errors).not_to include(att)
        end
      end
    end
    describe 'with validations set to nil' do
      before do
        user.validate_era_commons_name = nil
      end
      it 'attributes are not included in errors' do
        expect(user).not_to be_nil
        expect(user).not_to be_valid
        [:era_commons_name].each do |att|
          expect(user.errors).not_to include(att)
        end
      end
    end
  end

  describe '#key_personnel' do
    let(:key_person) { FactoryGirl.create(:key_person) }
    let(:user) { key_person.user }
    it 'returns KeyPerson associations' do
      expect(user.key_personnel).not_to be_blank
      expect(user).to eq user.key_personnel.first.user
    end
  end

  describe '#reviewers' do
    let(:reviewer) { FactoryGirl.create(:reviewer) }
    let(:user) { reviewer.user }
    it 'returns Reviewer associations' do
      expect(user.reviewers).not_to be_blank
      expect(user).to eq user.reviewers.first.user
      expect(user.reviewers.first.program).not_to be_blank
    end
  end

  describe '#submission_reviews' do
    let(:submission_review) { FactoryGirl.create(:submission_review) }
    let(:user) { submission_review.reviewer }
    it 'returns SubmissionReview associations' do
      expect(user.submission_reviews).not_to be_blank
      expect(user).to eq user.submission_reviews.first.reviewer
    end
  end

  describe '#reviewed_submissions' do
    let(:submission_review) { FactoryGirl.create(:submission_review) }
    let(:user) { submission_review.reviewer }
    it 'returns SubmissionReview associations' do
      expect(user.reviewed_submissions).not_to be_blank
    end
  end

  describe '#roles_users' do
    let(:ru) { FactoryGirl.create(:roles_user) }
    let(:user) { ru.user }
    it 'returns RolesUser associations' do
      expect(user.roles_users).not_to be_blank
      expect(user.roles_users.first.role).not_to be_blank
    end
  end

  context 'as applicant' do
    let(:submission) { FactoryGirl.create(:submission) }
    let(:user) { submission.applicant }
    describe '#submissions' do
      it 'returns Submission associations' do
        expect(user.submissions).not_to be_blank
        user.submissions.each do |submission|
          expect(submission.applicant).to eq user
        end
      end

      it 'is associated with a project' do
        user.submissions.each do |submission|
          expect(submission.project).not_to be_blank
        end
      end
    end

    describe '.project_applicants' do
      it 'returns applicants for a project' do
        project = user.submissions.first.project
        applicants = User.project_applicants(project.id)
        expect(applicants).not_to be_blank
        applicants.each do |applicant|
          expect(applicant).to eq applicant.submissions.first.applicant
        end
      end
    end
  end

  context 'as reviewer' do
    let(:reviewer) { FactoryGirl.create(:reviewer) }
    let(:user) { reviewer.user }

    describe '.program_reviewers' do
      it 'returns reviewers for a program' do
        reviewers = User.program_reviewers(reviewer.program_id)
        expect(reviewers).not_to be_blank
        expect(reviewers.first).not_to be_blank
      end
    end
  end

  context 'as submitter' do
    describe '#proxy_submissions' do
      let(:submission) { FactoryGirl.create(:submission) }
      let(:user) { submission.submitter }
      it 'returns Submission associations' do
        expect(user.proxy_submissions).not_to be_blank
        user.proxy_submissions.each do |submission|
          expect(submission.submitter).to eq user
        end
      end
    end
  end

  describe '.find_or_create_from_omniauth' do
    let(:netid) { 'netid' }
    let(:email) { 'username@gmail.com' }
    let(:nu_email) { 'netid@northwestern.edu' }
    let(:omniauth) do
      OmniAuth::AuthHash.new(
      {
        provider: 'nucatsmembership',
        uid: 99,
        info: OmniAuth::AuthHash.new(
          {
            name: 'John X. Doe',
            first_name: 'John',
            last_name: 'Doe',
            email: email,
          }
        ),
        extra: OmniAuth::AuthHash.new(
          {
            raw_info: OmniAuth::AuthHash.new(
            {
              name: 'John X. Doe',
              first_name: 'John',
              last_name: 'Doe',
              email: email,
              person_identities: [
                OmniAuth::AuthHash.new(
                {
                  provider: 'google_oauth2',
                  uid: '111111111111111111111',
                  email: email,
                  provider_username: nil,
                  username: nil,
                  nickname: nil,
                  domain: nil
                }),
                OmniAuth::AuthHash.new(
                {
                  provider: 'northwestern_medicine',
                  uid: "nu\\#{netid}",
                  email: nu_email,
                  provider_username: netid,
                  username: "nu\\#{netid}",
                  nickname: nil,
                  domain: 'nu'
                })
              ]
            })
          }
        )
      })
    end
    context 'for a new User' do
      it 'creates a User record with data from omniauth' do
        u = User.find_or_create_from_omniauth(omniauth)
        expect(u).to be_persisted
        expect(u).to be_an_instance_of(User)
        expect(u.username).to eq netid
      end
    end

    context 'for existing User records' do
      context 'with the same email address' do
        let!(:user) { FactoryGirl.create(:user, email: email, first_name: 'f', last_name: 'l') }
        it 'finds the User' do
          updated = User.find_or_create_from_omniauth(omniauth)
          expect(updated.id).to eq user.id
        end
      end

      context 'without an email address' do
        context 'with google oauth provider' do
          let!(:user) { FactoryGirl.create(:user, first_name: 'f', last_name: 'l', username: email) }
          it 'finds the User' do
            updated = User.find_or_create_from_omniauth(omniauth)
            expect(updated.id).to eq user.id
          end
        end

        context 'with the northwestern oauth provider' do
          let!(:user) { FactoryGirl.create(:user, first_name: 'f', last_name: 'l', username: netid) }
          it 'finds the User and updates User attributes' do
            updated = User.find_or_create_from_omniauth(omniauth)
            expect(updated.id).to eq user.id
          end
        end

        # It is quite possible that a User will be logged in using
        # differing providers resulting in more than one User record
        # having been created @see User.find_or_create_from_omniauth
        context 'with multiple oauth providers' do
          let!(:nu_user) { FactoryGirl.create(:user, first_name: 'f', last_name: 'l', username: netid) }
          let!(:ext_user) { FactoryGirl.create(:user, first_name: 'f', last_name: 'l', username: email) }
          it 'prefers the nu over outside if User exists matching both' do
            updated = User.find_or_create_from_omniauth(omniauth)
            expect(updated.id).to eq nu_user.id
            expect(updated.id).not_to eq ext_user.id
          end
        end
      end
    end
  end

  describe '#applicants' do
    let(:submission) { FactoryGirl.create(:submission) }
    let!(:applicant) { submission.applicant }
    let!(:submitter) { submission.submitter }
    let(:reviewer) { FactoryGirl.create(:reviewer) }
    let!(:user) { reviewer.user }

    it 'returns User records for Users who are applicants for Submissions' do
      applicants = User.applicants
      expect(applicants).to include(applicant)
      expect(applicants).not_to include(submitter)
      expect(applicants).not_to include(user)
    end
  end

end

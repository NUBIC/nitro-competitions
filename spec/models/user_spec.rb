require 'spec_helper'

describe User do

  it { should have_many(:reviewers) }
  it { should have_many(:key_personnel) }
  it { should have_many(:submission_reviews) }
  it { should have_many(:reviewed_submissions) }
  it { should have_many(:roles_users) }
  it { should have_many(:roles).through(:roles_users) }
  it { should have_many(:logs) }
  it { should have_many(:submissions) }
  it { should have_many(:proxy_submissions) }

  it { should belong_to(:biosketch) }

  it 'can be instantiated' do
    FactoryGirl.build(:user).should be_an_instance_of(User)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:user).should be_persisted
  end

  context 'user validations' do
    let(:user) { User.new }
    describe 'with validations set to true' do
      before do
        user.validate_email_attr = true
        user.validate_era_commons_name = true
      end
      it 'is not valid' do
        user.should_not be_nil
        user.should_not be_valid
        [:username, :first_name, :last_name, :email, :era_commons_name].each do |att|
          user.errors.should include(att)
        end
      end
    end
    describe 'with validations set to false' do
      before do
        user.validate_email_attr = false
        user.validate_era_commons_name = false
      end
      it 'attributes are not included in errors' do
        user.should_not be_nil
        user.should_not be_valid
        [:email, :era_commons_name].each do |att|
          user.errors.should_not include(att)
        end
      end
    end
    describe 'with validations set to nil' do
      before do
        user.validate_email_attr = nil
        user.validate_era_commons_name = nil
      end
      it 'attributes are not included in errors' do
        user.should_not be_nil
        user.should_not be_valid
        [:email, :era_commons_name].each do |att|
          user.errors.should_not include(att)
        end
      end
    end
  end

end
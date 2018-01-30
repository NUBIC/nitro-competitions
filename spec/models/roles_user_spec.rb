# -*- coding: utf-8 -*-

describe RolesUser, :type => :model do

  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:role) }
  it { is_expected.to have_many(:rights).through(:role) }

  let(:ru_admin) { FactoryGirl.create(:roles_user, role: Role.admin) }
  let(:ru_read) { FactoryGirl.create(:roles_user, role: Role.read_only) }

  describe "setup" do
    it 'can be instantiated' do
      expect(FactoryGirl.build(:roles_user)).to be_an_instance_of(RolesUser)
    end

    it 'can be saved successfully' do
      expect(ru_admin).to be_persisted
      expect(ru_read).to be_persisted
    end

    it 'has role' do
      expect(ru_admin.role).not_to be_nil
      expect(ru_read.role).not_to be_nil
    end

    it 'has user' do
      expect(ru_admin.user).not_to be_nil
      expect(ru_read.role).not_to be_nil
    end
  end

  describe ".read_only" do    
    describe "lists all the read_only users" do
      it "with one user" do
        expect(ru_read.role).not_to be_nil
        expect(RolesUser.read_only.count).to eq 1
        expect(RolesUser.read_only.first.role.name).to eq Role::READ_ONLY
      end
      it "with three users" do
        (1..3).each do |i|
          user = FactoryGirl.create(:user, username: "user#{i}")
          FactoryGirl.create(:roles_user, user: user, role: Role.read_only)
        end
        expect(RolesUser.read_only.count).to eq 3
      end
    end
  end

  describe ".admin" do    
    describe "lists all the admin users" do
      it "with one user" do
        expect(ru_admin.role).not_to be_nil
        expect(RolesUser.admins.count).to eq 1
        expect(RolesUser.admins.first.role.name).to eq Role::ADMIN
      end
      it "with three users" do
        (1..3).each do |i|
          user = FactoryGirl.create(:user, username: "user#{i}")
          FactoryGirl.create(:roles_user, user: user, role: Role.admin)
        end
        expect(RolesUser.admins.count).to eq 3
      end
    end
  end
end

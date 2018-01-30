# -*- coding: utf-8 -*-

describe Role, :type => :model do

  it { is_expected.to have_many(:roles_users) }
  it { is_expected.to have_many(:users).through(:roles_users) }
  it { is_expected.to have_and_belong_to_many(:rights) }


  it 'can be instantiated' do
    expect(FactoryGirl.build(:role)).to be_an_instance_of(Role)
  end

  it 'can be saved successfully' do
    expect(FactoryGirl.create(:role)).to be_persisted
  end

  describe ".admin" do
    context "role doesn't exist" do
      it "creates a role" do
        expect(Role.where(name: Role::ADMIN)).to be_blank 
        expect { Role.admin }.to change { Role.count }.by(1) 
      end

      it "returns a role" do
        role = Role.admin
        expect(role.name).to eq(Role::ADMIN)
      end
    end

    context "role does exist" do
      it "retrieves the role if it exists" do
        Role.admin
        expect(Role.where(name: Role::ADMIN).count).to eq(1)
        Role.admin
        expect(Role.where(name: Role::ADMIN).count).to eq(1)
      end
    end
  end

  describe ".read_only" do
    context "role doesn't exist" do
      it "creates a role" do
        expect(Role.where(name: Role::READ_ONLY)).to be_blank 
        expect { Role.read_only }.to change { Role.count }.by(1) 
      end

      it "returns a role" do
        role = Role.read_only
        expect(role.name).to eq(Role::READ_ONLY)
      end
    end

    context "role does exist" do
      it "retrieves the role if it exists" do
        Role.read_only
        expect(Role.where(name: Role::READ_ONLY).count).to eq(1)
        Role.admin
        expect(Role.where(name: Role::READ_ONLY).count).to eq(1)
      end
    end
  end


end

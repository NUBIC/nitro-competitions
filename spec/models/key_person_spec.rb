# -*- coding: utf-8 -*-

describe KeyPerson, :type => :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:submission) }

  context '#valid?' do
    it { is_expected.to validate_presence_of :role }
    it { is_expected.to validate_presence_of :username }
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
  end

  context 'new KeyPerson creation' do
    describe 'username with whitespace and Uppercase letters' do
      let(:key_person) { FactoryBot.create(:key_person, username: '  99UPPERCASE99  ', email: '  99UPPER@CASE.COM  ')}
      it 'strips whitespace and uppercase letters from username' do
        expect(key_person.username).to eq '99uppercase99'
      end
      it 'strips whitespace and uppercase letters from email' do
        expect(key_person.email).to eq '99upper@case.com'
      end
    end
  end

  context '#name normalization' do
    subject { KeyPerson.new(first_name: '   Name is combined with a space', last_name: 'and whitespace removed    ').name }
    it { is_expected.to eq("Name is combined with a space and whitespace removed") }
  end

  context '#sort_name' do
    subject { KeyPerson.new(first_name: 'First', last_name: 'Last').sort_name }
    it { is_expected.to eq('Last, First') }
  end
end

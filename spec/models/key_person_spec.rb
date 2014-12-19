# -*- coding: utf-8 -*-
require 'spec_helper'

describe KeyPerson, :type => :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:submission) }

  context '#valid?' do
    it { is_expected.to validate_presence_of :role }
    it { is_expected.to validate_presence_of :username }
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
  end

  context '#name' do
    it 'should combine first_name and last_name with a space' do
      fake_key_person = KeyPerson.new(first_name: 'Fake', last_name: 'Person')
      expect(fake_key_person.name).to eq("Fake Person")
    end

    it 'should strip leading whitespace' do
      fake_key_person = KeyPerson.new(first_name: '   Fake', last_name: 'Person')
      expect(fake_key_person.name).to eq("Fake Person")
    end

    it 'should strip trailing whitespace' do
      fake_key_person = KeyPerson.new(first_name: 'Fake', last_name: 'Person   ')
      expect(fake_key_person.name).to eq("Fake Person")
    end
  end

  context '#sort_name' do
    it 'should put first name last, joined with a command and space' do
      fake_key_person = KeyPerson.new(first_name: 'Fake', last_name: 'Person')
      expect(fake_key_person.sort_name).to eq("Person, Fake")
    end
  end
end

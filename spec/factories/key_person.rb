# -*- coding: utf-8 -*-
FactoryBot.define do
  factory :key_person do
    role 'MyString'
    sequence(:username) { |n| "username#{n}" }
    first_name 'MyString'
    last_name 'MyString'
    email 'MyString@dev.null'
    association :user, factory: :user
    association :submission, factory: :submission
  end
end

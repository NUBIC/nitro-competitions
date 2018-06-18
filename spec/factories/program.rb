# -*- coding: utf-8 -*-
FactoryBot.define do
  factory :program do
    sequence(:program_name) { |n| "n#{n}_#{Time.now.to_i}" }
    program_title 'MyString'
    program_url 'MyString'
    email 'test@test.com'
    association :creator, factory: :user
    created_ip '127.0.0.1'
    created_at Time.now
  end
end

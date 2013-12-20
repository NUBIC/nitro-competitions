# -*- coding: utf-8 -*-
FactoryGirl.define do
  sequence(:program_name) { |n| "program_name#{n}" }
  factory :program do
    program_name
    program_title 'MyString'
    program_url 'MyString'
    association :creater, factory: :user
    created_ip '127.0.0.1'
    created_at Time.now
  end
end
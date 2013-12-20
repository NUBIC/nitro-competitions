# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :log do
    activity 'MyString'
    association :user, factory: :user
    association :program, factory: :program
    association :project, factory: :project
    controller_name 'MyString'
    action_name 'MyString'
    params 'MyText'
    created_ip '127.0.0.1'
    created_at Time.now
  end
end
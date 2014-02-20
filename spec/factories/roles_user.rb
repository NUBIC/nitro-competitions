# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :roles_user do
    association :program, factory: :program
    association :user, factory: :user
    association :role, factory: :role
  end
end

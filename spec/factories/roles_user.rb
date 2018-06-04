# -*- coding: utf-8 -*-
FactoryBot.define do
  factory :roles_user do
    association :program, factory: :program
    association :user, factory: :user
    association :role, factory: :role
  end
end

# -*- coding: utf-8 -*-
FactoryBot.define do
  factory :reviewer do
    association :user, factory: :user
    association :program, factory: :program
  end
end

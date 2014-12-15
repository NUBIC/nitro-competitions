# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :reviewer do
    association :user, factory: :user
    association :program, factory: :program
  end
end
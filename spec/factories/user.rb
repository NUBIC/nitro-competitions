# -*- coding: utf-8 -*-
FactoryGirl.define do
  sequence(:username) { |n| "username#{n}" }
  sequence(:email) { |n| "email#{n}@dev.null" }
  factory :user do
    username
    first_name 'MyString'
    last_name 'MyString'
    middle_name 'MyString'
    era_commons_name 'MyString'
    email
    degrees 'MyString'
    business_phone 'MyString'
    title 'MyString'
    employee_id 1
    primary_department 'MyString'
    campus 'MyString'
    campus_address '123Blah'
    address 'MyText'
    city 'MyString'
    postal_code 'MyString'
    state 'MyString'
    country 'MyString'
    first_login_at Time.now
    last_login_at Time.now
    biosketch_document_id 1
    created_ip '127.0.0.1'
    created_at Time.now
  end
end
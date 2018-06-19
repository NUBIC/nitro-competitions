# -*- coding: utf-8 -*-
FactoryBot.define do
  factory :user do
    association :biosketch_document_id, factory: :file_document
    sequence(:username) { |n| "username#{n}_#{Time.now.to_i}" }
    sequence(:email) { |n| "email#{n}_#{Time.now.to_i}@dev.null" }
    first_name 'FName'
    last_name 'LName'
    middle_name 'MyString'
    era_commons_name 'MyString'
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
    created_ip '127.0.0.1'
    created_at Time.now
    password 'password'
    should_receive_submission_notifications true
    system_admin false
  end
end

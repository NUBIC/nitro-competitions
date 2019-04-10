FactoryBot.define do
  # This is an external user
  factory :user do
    association :biosketch_document_id, factory: :file_document
    sequence(:email) { |n| "email#{n}_#{Time.now.to_i}@dev.com" }
    sequence(:username) { email }
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
    first_login_at DateTime.yesterday
    last_login_at DateTime.yesterday
    created_ip '127.0.0.1'
    created_at DateTime.yesterday
    encrypted_password 'password'
    should_receive_submission_notifications true
    system_admin false
    type 'ExternalUser'
    confirmed_at DateTime.yesterday

    trait :ldap do
      state { 'demo' }
    end
  end


  trait :ldap do
    # password 'password'
    type 'LdapUser'
    confirmed_at nil
  end

  factory :ldap_user,       traits: %i[ldap]
end
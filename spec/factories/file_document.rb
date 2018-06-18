# -*- coding: utf-8 -*-
FactoryBot.define do
  factory :file_document do
    file_content_type 'html/text'
    file_file_name 'MyString'
    file File.new(Rails.root + 'spec/factories/documents/test.txt')
  end
end

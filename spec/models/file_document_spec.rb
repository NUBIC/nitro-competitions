# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: file_documents
#
#  id                :integer          not null, primary key
#  created_id        :integer
#  created_ip        :string(255)
#  updated_id        :integer
#  updated_ip        :string(255)
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  last_updated_at   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'spec_helper'

describe FileDocument, :type => :model do

  it 'can be instantiated' do
    expect(FactoryGirl.build(:file_document)).to be_an_instance_of(FileDocument)
  end

  it 'can be saved successfully' do
    expect(FactoryGirl.create(:file_document)).to be_persisted
  end
end

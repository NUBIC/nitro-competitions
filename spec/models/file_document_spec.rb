# -*- coding: utf-8 -*-
require 'spec_helper'

describe FileDocument, :type => :model do

  it 'can be instantiated' do
    expect(FactoryGirl.build(:file_document)).to be_an_instance_of(FileDocument)
  end

  it 'can be saved successfully' do
    expect(FactoryGirl.create(:file_document)).to be_persisted
  end
end

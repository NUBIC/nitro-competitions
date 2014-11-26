# -*- coding: utf-8 -*-
require 'spec_helper'

describe FileDocument do

  it 'can be instantiated' do
    FactoryGirl.build(:file_document).should be_an_instance_of(FileDocument)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:file_document).should be_persisted
  end
end

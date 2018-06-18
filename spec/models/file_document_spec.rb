# -*- coding: utf-8 -*-

describe FileDocument, :type => :model do

  it 'can be instantiated' do
    expect(FactoryBot.build(:file_document)).to be_an_instance_of(FileDocument)
  end

  it 'can be saved successfully' do
    expect(FactoryBot.create(:file_document)).to be_persisted
  end
end

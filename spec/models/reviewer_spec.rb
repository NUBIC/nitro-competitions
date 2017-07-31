# -*- coding: utf-8 -*-

describe Reviewer, :type => :model do

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:program) }

  it 'can be instantiated' do
    expect(FactoryGirl.build(:reviewer)).to be_an_instance_of(Reviewer)
  end

  let(:reviewer) { FactoryGirl.create(:reviewer) }

  it 'can be saved successfully' do
    expect(reviewer).to be_persisted
  end

  it 'has program' do
    expect(reviewer.program).not_to be_nil
  end

  it 'has user' do
    expect(reviewer.user).not_to be_nil
  end

end

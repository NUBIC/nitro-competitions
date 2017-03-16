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

describe FileDocumentsController, :type => :controller do
  context 'with a logged in user' do
    user_login
    describe 'GET show' do
      context 'with a valid file_document record' do
        let(:file_document) { FactoryGirl.create(:file_document) }
        it 'renders the page' do
          get :show, :id => file_document
          expect(response).to be_success
        end
        it 'assigns variables' do
          get :show, :id => file_document
          expect(assigns[:file_document]).to eq file_document
        end
      end
      context 'with an invalid record' do
        it 'raises ActiveRecord::RecordNotFound' do
          expect { get :show, :id => -1 }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end

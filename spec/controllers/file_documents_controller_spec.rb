# -*- coding: utf-8 -*-

describe FileDocumentsController, :type => :controller do
  context 'with a logged in user' do
    user_login
    describe 'GET show' do
      context 'with a valid file_document record' do
        let(:file_document) { FactoryBot.create(:file_document) }
        it 'renders the page' do
          process :show, method: :get, params: { id: file_document }
          expect(response).to be_success
        end
        it 'assigns variables' do
          process :show, method: :get, params: { id: file_document }
          expect(assigns[:file_document]).to eq file_document
        end
      end
      context 'with an invalid record' do
        it 'raises ActiveRecord::RecordNotFound' do
          expect { process :show, method: :get, params: { id: -1 } }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end

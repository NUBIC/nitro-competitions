# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: submissions
#
#  id                                :integer          not null, primary key
#  project_id                        :integer
#  applicant_id                      :integer
#  submission_title                  :string(255)
#  submission_status                 :string(255)
#  is_human_subjects_research        :boolean
#  is_irb_approved                   :boolean
#  irb_study_num                     :string(255)
#  use_nucats_cru                    :boolean
#  nucats_cru_contact_name           :string(255)
#  use_stem_cells                    :boolean
#  use_embryonic_stem_cells          :boolean
#  use_vertebrate_animals            :boolean
#  is_iacuc_approved                 :boolean
#  iacuc_study_num                   :string(255)
#  direct_project_cost               :float
#  is_new                            :boolean
#  use_nmh                           :boolean
#  use_nmff                          :boolean
#  use_va                            :boolean
#  use_ric                           :boolean
#  use_cmh                           :boolean
#  not_new_explanation               :text
#  other_funding_sources             :text
#  is_conflict                       :boolean
#  conflict_explanation              :text
#  effort_approver_ip                :string(255)
#  submission_at                     :datetime
#  completion_at                     :datetime
#  effort_approver_username          :string(255)
#  department_administrator_username :string(255)
#  effort_approval_at                :datetime
#  submission_reviews_count          :integer          default(0)
#  submission_category               :string(255)
#  core_manager_username             :string(255)
#  cost_sharing_amount               :float
#  cost_sharing_organization         :text
#  received_previous_support         :boolean          default(FALSE)
#  previous_support_description      :text
#  committee_review_approval         :boolean          default(FALSE)
#  application_document_id           :integer
#  budget_document_id                :integer
#  abstract                          :text
#  other_support_document_id         :integer
#  document1_id                      :integer
#  document2_id                      :integer
#  document3_id                      :integer
#  document4_id                      :integer
#  applicant_biosketch_document_id   :integer
#  notification_cnt                  :integer          default(0)
#  notification_sent_at              :datetime
#  notification_sent_by_id           :integer
#  notification_sent_to              :string(255)
#  created_id                        :integer
#  created_ip                        :string(255)
#  updated_id                        :integer
#  updated_ip                        :string(255)
#  deleted_at                        :datetime
#  deleted_id                        :integer
#  deleted_ip                        :string(255)
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  supplemental_document_id          :integer
#  total_amount_requested            :float
#  amount_awarded                    :float
#  type_of_equipment                 :string
#

describe SubmissionsController, :type => :controller do


  context 'with a logged in user' do
    user_login

    describe 'GET index' do
      it 'renders the page' do
        get :index
        expect(response).to be_success
      end
      it 'assigns variables' do
        get :index
        expect(assigns[:submissions]).not_to be_nil
      end
    end

    describe 'GET new' do
      context 'without parameters' do
        it 'redirects to projects_path' do
          get :new
          expect(response).to redirect_to(projects_path)
        end
      end
    end

    describe 'GET show' do
      let(:submission) { FactoryGirl.create(:submission) }
      context 'where the current logged in user is associated with the submission' do
        before do
          allow(Submission).to receive(:associated_with_user).and_return([submission])
        end
        it 'renders the page' do
          get :show, :id => submission.id
          expect(response).to be_success
        end
      end
      context 'where the current logged in user is not associated with the submission' do
        it 'redirects the user to the project_submissions_path' do
          get :show, :id => submission.id
          expect(response).to redirect_to(project_submissions_path(submission.project))
        end
      end
    end

    describe 'GET edit' do
      let(:submission) { FactoryGirl.create(:submission) }
      it 'renders the page' do
        get :edit, :id => submission.id
        expect(response).to be_success
      end
    end

  end

  # test "should not create submission redirect to projects" do
  #   assert_difference('Submission.count', 0) do
  #     post :create, :submission => { }
  #   end
  #   assert_not_nil assigns(:submission)
  #   assert_nil assigns(:applicant)
  #   assert_nil assigns(:project)

  #   assert_redirected_to projects_path
  # end

  # test "should not create submission redirect to project one" do
  #   assert_difference('Submission.count', 0) do
  #     post :create, {:project_id => projects(:one).to_param, :submission => { :project_id => projects(:one).to_param, :submission_title=>'this is a test', :direct_project_cost=>5000} }
  #   end
  #   assert_not_nil assigns(:submission)
  #   assert_nil assigns(:applicant)
  #   assert_not_nil assigns(:project)

  #   assert_same assigns(:project).id, projects(:one).id

  #   assert_redirected_to project_path(projects(:one).to_param)
  # end

  # test "should create valid submission" do
  #   post :create, {:project_id => projects(:one).to_param, :applicant_id => users(:one).to_param, :submission => { :project_id => projects(:one).to_param, :submission_title=>'this is a test', :direct_project_cost=>5000} }
  #   assert_not_nil assigns(:submission)
  #   assert_not_nil assigns(:applicant)
  #   assert_not_nil assigns(:project)
  #   assert assigns(:submission).valid?
  # end

  # test "should create submission" do
  #   assert_difference('Submission.count') do
  #     post :create, {:project_id => projects(:one).to_param, :applicant_id => users(:one).to_param, :submission => { :project_id => projects(:one).to_param, :submission_title=>'this is a test', :direct_project_cost=>5000} }
  #   end
  #   assert_not_nil assigns(:submission)
  #   assert_not_nil assigns(:applicant)
  #   assert_not_nil assigns(:project)

  #   assert_response :success
  #   assert_not_nil assigns(:project)
  #   assert_template 'submissions/edit_documents'
  # end

  # test "should update submission" do
  #   put :update, :id => submissions(:one).to_param, :submission => { }
  #   assert_response :redirect
  #   assert_redirected_to project_path(submissions(:one).project_id)
  # end

  # test "should not destroy submission" do
  #   # need to be owner
  #   assert_difference('Submission.count', 0) do
  #     delete :destroy, :id => submissions(:one).to_param
  #   end

  #   assert_redirected_to project_path(submissions(:one).project_id)
  # end
end

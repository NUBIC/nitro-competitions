# spec/services/project_services/duplication_spec.rb
RSpec.describe ProjectServices::Duplicate do
  context "integration tests" do
    before(:each) do
      @project = FactoryGirl.create(:project, visible: true)
      @new_project = ProjectServices::Duplicate.call(@project.id)
    end

    it 'returns a Project' do
     expect(@new_project).to be_a(Project)
    end

    it 'unsets new project visibility' do
      expect(@project.visible).to be(true)
      expect(@new_project.visible).to be(false)
    end

    it 'unsets new project dates' do
      expect(@new_project.initiation_date).to be_nil
      expect(@new_project.submission_open_date).to be_nil
      expect(@new_project.submission_close_date).to be_nil
      expect(@new_project.review_start_date).to be_nil
      expect(@new_project.review_end_date).to be_nil
      expect(@new_project.project_period_start_date).to be_nil
      expect(@new_project.project_period_end_date).to be_nil
    end
  end
end

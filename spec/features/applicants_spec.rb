# -*- coding: utf-8 -*-

describe 'Applying for a competitions', type: :feature do

  context 'With an open competition', js: true do

    # setup - populate necessary data for an applicant to be able to apply to a competition
    before :each do
      program = FactoryBot.create(:program)
      project = FactoryBot.create(:project, project_title: 'Voucher Program',
                         program: program,
                         submission_close_date: 1.week.from_now,
                         submission_open_date: 1.day.ago,
                         initiation_date: 1.day.ago,
                         visible: true)
    end

    context 'with a logged in applicant' do
      it 'should allow the applicant to apply' do
        login
        visit '/projects'
        last_project = Project.last
        user = User.last
        expect(page).to have_content 'Apply'

        click_link 'Apply'
        expect(current_path).to eq("/projects/#{last_project.id}/applicants/new")

        scroll_to_bottom_of_the_page
        click_button 'Continue'
        expect(current_path).to eq("/projects/#{last_project.id}/applicants/#{user.id}/submissions/new")

        fill_in 'submission_direct_project_cost', with: '5555' # todo: test that amount is within range
        fill_in 'submission_abstract', with: 'Abstractions' # todo: test required fields
        fill_in 'submission_submission_title', with: 'The Title' # todo: test title character length

        ###
        # using node.trigger('click') due to poltergeist error:
        # "Firing a click at co-ordinates [48.5, 724] failed.
        #  Poltergeist detected another element with CSS selector 'html body div.pushit' at this position.
        #  It may be overlapping the element you are trying to interact with.
        #  If you don't care about overlapping elements, try using node.trigger('click')."
        ###
        # previous:

        scroll_to_bottom_of_the_page
        click_button 'Continue'
        # expect(current_path).to eq("/projects/#{last_project.id}/applicants/#{user.id}/submissions")
        # current:
        # find('#continue').trigger('click')

        scroll_to_bottom_of_the_page
        expect(page).to have_content 'Application Process - Step 3 (last step!)'
        attach_file 'submission_uploaded_application', "#{Rails.root}/spec/support/test_upload_document.txt"
        attach_file 'submission_uploaded_other_support', "#{Rails.root}/spec/support/test_upload_document.txt"
        click_button 'Submit'
        expect(page).to have_content "Submission 'The Title' was successfully updated and is COMPLETE!!"
      end

    end


  end

end

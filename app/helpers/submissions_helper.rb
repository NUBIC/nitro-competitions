# -*- coding: utf-8 -*-

# Helper module for Submissions model
module SubmissionsHelper
  require "#{Rails.root}/app/helpers/application_helper"
  include ApplicationHelper

  def link_to_key_personnel_documents(key_people, do_lookup = true, include_name = true)
    out = ''
    key_people.each_with_index do |key_user, index|
      title = "Biosketch for #{key_user.name}"
      unless key_user.blank? || key_user.biosketch_document_id.blank?
        out << link_to_file(key_user.biosketch_document_id, title, 'document', title, false, nil, do_lookup)
        out << '<br/> '
      end
    end
    out
  end

  def link_to_project_docs(project)
    %{
      Docs:
      #{link_to_rfa(project)}
      #{link_to_application_documents(project)}
      #{link_to_budget_documents(project)}
    }
  end

  def link_to_rfa(project)
    project.project_url.blank? ? '' : link_to_document(project.project_url_label, project.project_url)
  end

  def link_to_application_documents(project)
    link_to_application_template(project) + link_to_application_info(project)
  end

  def link_to_application_info(project)
    project.application_info_url.blank? ? '' : ' ' + link_to_document(project.application_info_url_label, project.application_info_url)
  end

  def link_to_application_template(project)
    project.application_template_url.blank? ? '' : link_to_document(project.application_template_url_label, project.application_template_url)
  end

  def link_to_application_info(project)
    project.application_info_url.blank? ? '' : ' ' + link_to_document(project.application_info_url_label, project.application_info_url)
  end

  def link_to_budget_documents(project)
    link_to_budget_template + link_to_budget_info(project)
  end

  def link_to_budget_template(project)
    project.budget_template_url.blank? ? '' : link_to_document(project.budget_template_url_label, project.budget_template_url)
  end

  def link_to_budget_info(project)
    project.budget_info_url.blank? ? '' : ' ' + link_to_document(project.budget_info_url_label, project.budget_info_url)
  end

  def link_to_other_support_documents
    %{
      #{link_to('NIH Other Support Template', 'http://grants.nih.gov/grants/funding/phs398/othersupport.doc', title: 'Download NIH Other Support Template', target: '_blank')}
      #{link_to('PHS398 instructions', 'http://grants.nih.gov/grants/funding/phs398/phs398.html', title: 'View PHS398 instructions', target: '_blank')}
     .
   }
  end

  def link_to_nih_biosketch_info
    %{
      Download the NIH Biosketch template as a
      #{link_to('MS Word document', 'http://grants.nih.gov/grants/funding/phs398/biosketch.doc', title: 'NIH Biosketch Template as a MS Word document', target: '_blank')}
     or
      #{link_to('PDF document', 'http://grants.nih.gov/grants/funding/phs398/biosketchsample.pdf', title: 'NIH Biosketch Sample as a PDF', target: '_blank')}
    }
  end

  def link_to_document_template(project, number)
    if project.send("document#{number}_template_url").blank?
      ''
    else
      link_to_document(project.send("document#{number}_name") + ' Template', project.send("document#{number}_template_url"))
    end
  end

  def link_to_document_info(project, number)
    if project.send("document#{number}_info_url").blank?
      ''
    else
      ' ' + link_to_document(project.send("document#{number}_name") + ' Info',
                             project.send("document#{number}_info_url"),
                             project.send("document#{number}_name") + 'Instructions and Information')
    end
  end

  def link_to_document1_template_info(project)
    link_to_document_template(project, 1) + link_to_document_info(project, 1) + '.'
  end

  def link_to_document2_template_info(project)
    link_to_document_template(project, 2) + link_to_document_info(project, 2) + '.'
  end

  def link_to_document3_template_info(project)
    link_to_document_template(project, 3) + link_to_document_info(project, 3) + '.'
  end

  def link_to_document4_template_info(project)
    link_to_document_template(project, 4) + link_to_document_info(project, 4) + '.'
  end

  def link_to_submission_pdf(submission)
    link_to_download('Submission pdf ', submission_path(submission.id, format: :pdf), 'pdf', "'#{submission.submission_title}' submission form as pdf")
  end

  def link_to_document(link_prefix, path, title = nil)
    title ||= link_prefix
    link_to_download(link_prefix, path, 'document', title)
  end

  def link_to_spreadsheet(link_prefix, path, title = nil)
    title ||= link_prefix
    link_to_download(link_prefix, path, 'spreadsheet', title)
  end

  def link_to_download(link_text, path, file_type = 'document', mouse_over = nil)
    mouse_over ||= link_text
    # TODO: reinsert image
    # image_name = determine_image_name(file_type)
    # link_text+' '+image_tag(image_name, :width=>"16px", :height=>"16px" )
    # currently does not work with Rails 3
    link_to(link_text, path, title: 'Download ' + mouse_over, target: '_blank')
  end

  def determine_image_name(file_type)
    case file_type
    when :document, 'document', 'txt'
      'page_white_put.png'
    when :spreadsheet, 'spreadsheet'
      'page_excel.png'
    when :pdf, 'pdf'
      'page_white_acrobat.png'
    else
      'documenticon.gif'
    end
  end

  def list_key_personnel_documents_as_array(key_people)
    out = []
    key_people.each_with_index do |key_user, index|
      out << "Biosketch for #{key_user.name} : " + format_document_info(key_user.biosketch) unless key_user.biosketch_document_id.blank?
    end
    out
  end

  def list_submission_files_as_array(submission)
    out = []
    out << "PI biosketch: #{format_document_info(submission.applicant_biosketch_document)}" unless submission.applicant_biosketch_document_id.blank?
    out << "Application doc: #{format_document_info(submission.application_document)}" unless submission.application_document_id.blank?
    out << "Budget doc: #{format_document_info(submission.budget_document)}" unless submission.budget_document_id.blank?
    out << "Other Support doc: #{format_document_info(submission.other_support_document)}" unless submission.other_support_document_id.blank?
    out << "#{submission.project.document1_name} doc: " + format_document_info(submission.document1) unless !submission.project.show_document1 || submission.document1_id.blank?
    out << "#{submission.project.document2_name} doc: " + format_document_info(submission.document2) unless !submission.project.show_document2 || submission.document2_id.blank?
    out << "#{submission.project.document3_name} doc: " + format_document_info(submission.document3) unless !submission.project.show_document3 || submission.document3_id.blank?
    out << "#{submission.project.document4_name} doc: " + format_document_info(submission.document4) unless !submission.project.show_document4 || submission.document4_id.blank?
    out << list_key_personnel_documents_as_array(submission.key_people)
    out.flatten.compact
  end

  def link_to_submission_files_as_array(submission, project, lookup = true)
    [
      link_to_file(submission.applicant_biosketch_document_id,
                   'PI biosketch',
                   'document',
                   'PI biosketch ',
                   project.show_manage_biosketches,
                   edit_documents_submission_path(submission.id),
                   lookup),
      link_to_file(submission.application_document_id,
                   'Application',
                   'document',
                   nil,
                   true,
                   edit_documents_submission_path(submission.id),
                   lookup),
      link_to_file(submission.budget_document_id,
                   'Budget',
                   'spreadsheet',
                   'Budget ',
                   project.show_budget_form,
                   edit_documents_submission_path(submission.id),
                   lookup),
      link_to_file(submission.other_support_document_id,
                   'Other Support',
                   'document',
                   'Other Support',
                   project.show_manage_other_support,
                   edit_documents_submission_path(submission.id),
                   lookup),
      link_to_file(submission.document1_id,
                   'Doc 1',
                   'document',
                   project.document1_name,
                   project.show_document1,
                   edit_documents_submission_path(submission.id),
                   lookup),
      link_to_file(submission.document2_id,
                   'Doc 2',
                   'document',
                   project.document2_name,
                   project.show_document2,
                   edit_documents_submission_path(submission.id),
                   lookup),
      link_to_file(submission.document3_id,
                   'Doc 3',
                   'document',
                   project.document3_name,
                   project.show_document3,
                   edit_documents_submission_path(submission.id),
                   lookup),
      link_to_file(submission.document4_id,
                   'Doc 4',
                   'document',
                   project.document4_name,
                   project.show_document4,
                   edit_documents_submission_path(submission.id),
                   lookup),
      link_to_key_personnel_documents(submission.key_people, true, false)
    ].compact
  end

  def link_to_submission_files(submission, project, lookup = true)
    link_to_submission_files_as_array(submission, project, lookup)
  end
end

jQuery( function() {
  jQuery( ".datepicker" ).datepicker({dateFormat: 'yy-mm-dd'});
});
jQuery('.project').validate({
  rules: {
    "project[project_title]": {
      required: true,
      maxlength: 255,
      minlength: 10
    },
    "project[project_name]": {
      required: true,
      maxlength: 25,
      minlength: 2
    },
    "project[submission_open_date]": {
      required: true,
    },
    "project[submission_close_date]": {
      required: true,
    },
    "project[review_start_date]": {
      required: true,
    },
    "project[review_end_date]": {
      required: true,
    },
    "project[project_url]": {
      maxlength: 255,
    },
    "project[status]": {
      maxlength: 255,
    },
    "project[review_guidance_url]": {
      maxlength: 255,
    },
    "project[overall_impact_title]": {
      maxlength: 255,
    },
    "project[impact_title]": {
      maxlength: 255,
    },
    "project[team_title]": {
      maxlength: 255,
    },
    "project[innovation_title]": {
      maxlength: 255,
    },
    "project[scope_title]": {
      maxlength: 255,
    },
    "project[environment_title]": {
      maxlength: 255,
    },
    "project[other_title]": {
      maxlength: 255,
    },
    "project[budget_title]": {
      maxlength: 255,
    },
    "project[completion_title]": {
      maxlength: 255,
    },
    "project[abstract_text]": {
      maxlength: 255,
    },
    "project[manage_other_support_text]": {
      maxlength: 255,
    },
    "project[document1_name]": {
      maxlength: 255,
    },
    "project[document1_description]": {
      maxlength: 255,
    },
    "project[document1_template_url]": {
      maxlength: 255,
    },
    "project[document1_info_url]": {
      maxlength: 255,
    },
    "project[project_url_label]": {
      maxlength: 255,
    },
    "project[application_template_url]": {
      maxlength: 255,
    },
    "project[application_template_url_label]": {
      maxlength: 255,
    },
    "project[application_info_url]": {
      maxlength: 255,
    },
    "project[application_info_url_label]": {
      maxlength: 255,
    },
    "project[budget_template_url]": {
      maxlength: 255,
    },
    "project[budget_template_url_label]": {
      maxlength: 255,
    },
    "project[budget_info_url]": {
      maxlength: 255,
    },
    "project[budget_info_url_label]": {
      maxlength: 255,
    },
    "project[document2_name]": {
      maxlength: 255,
    },
    "project[document2_description]": {
      maxlength: 255,
    },
    "project[document2_template_url]": {
      maxlength: 255,
    },
    "project[document2_info_url]": {
      maxlength: 255,
    },
    "project[document3_name]": {
      maxlength: 255,
    },
    "project[document3_description]": {
      maxlength: 255,
    },
    "project[document3_template_url]": {
      maxlength: 255,
    },
    "project[document3_info_url]": {
      maxlength: 255,
    },
    "project[document4_name]": {
      maxlength: 255,
    },
    "project[document4_description]": {
      maxlength: 255,
    },
    "project[document4_template_url]": {
      maxlength: 255,
    },
    "project[document4_info_url]": {
      maxlength: 255,
    },
    "project[submission_category_description]": {
      maxlength: 255,
    },
    "project[application_doc_name]": {
      maxlength: 255,
    },
    "project[application_doc_description]": {
      maxlength: 255,
    },
    "project[supplemental_document_name]": {
      maxlength: 255,
    },
    "project[supplemental_document_description]": {
      maxlength: 255,
    },
    "project[closed_status_wording]": {
      maxlength: 255,
    },
  }
});
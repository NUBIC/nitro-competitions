jQuery('.submission').validate({
  rules: {
    "submission[submission_title]": {
      required: true,
      maxlength: 200,
      minlength: 6
    },
    "submission[submission_status]": {
      maxlength: 255,
    },
    "submission[irb_study_num]": {
      maxlength: 255,
    },
    "submission[nucats_cru_contact_name]": {
      maxlength: 255,
    },
    "submission[iacuc_study_num]": {
      maxlength: 255,
    },
    "submission[effort_appprover_username]": {
      maxlength: 255,
    },
    "submission[department_administrator_username]": {
      maxlength: 255,
    },
    "submission[submission_category]": {
      maxlength: 255,
    },
    "submission[core_manager_username]": {
      maxlength: 255,
    },
    "submission[notification_sent_to]": {
      maxlength: 255,
    },
    "submission[type_of_equipment]": {
      maxlength: 255,
    },
  }
});
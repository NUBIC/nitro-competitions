# -*- coding: utf-8 -*-

module KeyPersonnelHelper

  def key_personnel_lookup_observer(submission_id, root_name, index)
    # observe_field(root_name + '_username',
    #               frequency: 0.5,
    #               before: "Element.show('spinner')",
    #               complete: "Element.hide('spinner')",
    #               url: lookup_submission_key_personnel_path(submission_id),
    #               with: "'username=' + encodeURIComponent(value) + '&role=' + encodeURIComponent($('" + root_name.to_s +
    #                     "_role').getValue()) + '&index='+encodeURIComponent(" + index + ')')
  end

  def add_key_person(user, submission_id = 0, role = '')
    submission_id = 0 if submission_id.blank?
    key = KeyPerson.where('user_id = :user_id and submission_id = :submission_id', { user_id: user.id, submission_id: submission_id }).first
    if key.blank? || key.id.blank?
      key = KeyPerson.new
      key.user_id          = user.id
      key.submission_id    = submission_id
      key.username         = user.username
      key.first_name       = user.first_name
      key.last_name        = user.last_name
      key.email            = user.email unless user.email.blank?
      key.role             = role
      key.save! unless submission_id.to_i < 1
    else
      key.email            = user.email unless user.email.blank?
      key.role             = role
      key.save!
    end
    key
  end

  def handle_key_personnel_param(submission)
    if defined?(params) && params[:key_personnel].present?
      incoming_usernames = Array.new

      params[:key_personnel].each { |_, new_person| incoming_usernames << new_person[:username].strip.downcase! }

      submission.key_personnel.each do |existing_key_person|
        existing_key_person.destroy if incoming_usernames.blank? || !incoming_usernames.include?(existing_key_person.username)
      end

      params[:key_personnel].each do |_, key_person|
        unless key_person['username'].blank?

          prepared_email = key_person['email'].strip.downcase! if key_person['email'].respond_to?(:strip)
          prepared_username = key_person['username'].strip.downcase! if key_person['username'].respond_to?(:strip)

          key_user = make_user(prepared_username, prepared_email)

          if key_user.blank? && !prepared_username.blank? && !key_person['first_name'].blank? && !key_person['last_name'].blank?
            key_user = ExternalUser.new
            key_user.username       = prepared_username
            key_user.email          = prepared_email
            key_user.first_name     = key_person['first_name']
            key_user.last_name      = key_person['last_name']
            key_user.password       = Devise.friendly_token[0,20]
            before_create(key_user)
            key_user.save!

            Rails.logger.info "Making user with username #{key_user.username}"
          else
            key_user.email            = prepared_email unless prepared_email.blank?
            key_user.first_name       = key_person['first_name']
            key_user.last_name        = key_person['last_name']
            before_update(key_user)
          end

          add_key_person(key_user, submission.id, key_person['role']) unless key_user.nil? || key_user.id.blank? || submission.id.blank?

          unless key_user.nil? || key_user.id.blank? || key_person['uploaded_biosketch'].blank?
            key_user.uploaded_biosketch  = key_person['uploaded_biosketch']
            key_user.validate_email_attr = false
            key_user.save!
          end
        end
      end
    end
  end

end

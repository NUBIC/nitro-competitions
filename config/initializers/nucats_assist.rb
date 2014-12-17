# -*- coding: utf-8 -*-

##
# Project specific constants.
module NucatsAssist
  VERSION = '2.3.7'

  class << self
    def plain_app_name
      'NITROCompetitions'
    end
  
    def html_app_name
      '<b>NITRO</b>Competitions'.html_safe
    end

    def email_subject
      "FROM NITROCompetitions"
    end

    def ctsa_name
      'NUCATS'
    end

    def ctsa_membership_app_name
      'myNUCATS'
    end

    def institute_id_name
      'NU NetID'
    end

    def allowable_ip_locations
      'Northwestern, CMH, NMFF, NorthShore, and NMH'
    end

    def root_url
      'https://grants.nubic.northwestern.edu'
    end

    def era_commons_name_url
      'http://www.research.northwestern.edu/osr/commons.html'
    end

    def ldap_url
      'http://directory.northwestern.edu/'
    end

    def ldap_link_title
      'Click here to go to the Northwestern Directory to look up netids'
    end

    def from_email_address
      'competitions@northwestern.edu'
    end

    def app_support_email_address
      'competitions@northwestern.edu'
    end

    def mail_to_app_support_href
      "mailto:#{app_support_email_address}"
    end

    def exception_subject_prefix
      "[#{Rails.env}] NITROCompetitions "
    end

    def exception_from_email
      "'NC-notifier [#{Rails.env}]' <p-friedman@northwestern.edu>"
    end

    def exception_recipients
      %w{p-friedman@northwestern.edu jeff.lunt@northwestern.edu}
    end

    def admin_email_addresses
      %w{p-friedman@northwestern.edu jeff.lunt@northwestern.edu wakibbe@northwestern.edu}
    end

    def admin_netids
      %w{pfr957 jml588 wakibbe}
    end

    def cru_contact_email
      'b-ferry@northwestern.edu'
    end

    def cru_contact_email_text
      'b-ferry@northwestern.edu'
    end

    def cru_url
      'http://www.nucats.northwestern.edu/resources-services/research-study-support/'
    end

    def app_sponsors_text
      'The Northwestern University Clinical and Translational Sciences Institute'
    end

    def app_sponsors_url
      'http://www.nucats.northwestern.edu'
    end

    def nubic_url
      'http://www.nucats.northwestern.edu/resources-services/data-and-informatics-services/'
    end
  end
end

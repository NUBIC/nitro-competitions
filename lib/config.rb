require "#{Rails.root}/app/helpers/roles_helper"
include RolesHelper

def default_program_name
  'CTI'
end

def allow_emails?
  true
end

def image_name
  'pageheader.jpg'
end

def allowed_ips
  # childrens: 199.125.
  # nmff: 209.107.
  # nmh: 165.20.
  # enh: 204.26
  # ric: 69.216
  [':1','127.0.*','165.124.*','129.105.*','199.125.*','209.107.*','165.20.*','204.26.*','69.216.*']
end

def do_ajax?
  (is_admin? and Rails.env != 'production') ? false : true
  true
end

def do_ldap?
  (is_admin? and Rails.env != 'production') ? false : true
  true
end

def cleanup_campus(thePI)
  #clean up the campus data
  thePI.campus = (thePI.campus =~ /CH|Chicago/) ? 'Chicago' : thePI.campus
  thePI.campus = (thePI.campus =~ /EV|Evanston/) ? 'Evanston' : thePI.campus
  thePI.campus = (thePI.campus =~ /CMH|Children/) ? 'CMH' : thePI.campus
  thePI
end

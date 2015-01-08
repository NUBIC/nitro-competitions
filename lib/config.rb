require "#{Rails.root}/app/helpers/roles_helper"
include RolesHelper

def default_program_name
  'CTI'
end

def image_name
  'pageheader.jpg'
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

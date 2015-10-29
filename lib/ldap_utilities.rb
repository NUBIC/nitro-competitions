require 'net/ldap'
require 'config' # has cleanup_campus method
require 'ldap_config'

def GetLDAPentry(uid)
  return nil if !ldap_perform_search? || uid.blank? 
  search_ldap('uid', uid)
end

def GetLDAPentryFromEmail(email)
  return nil if !ldap_perform_search? || email.blank?
  search_ldap('mail', email)
end

def GetLDAPentryFromName(name)
  return nil if !ldap_perform_search? || name.blank? 
  search_ldap('cn', name)
end

def search_ldap(filter_name, filter_value)
  ldap_connection = Net::LDAP.new(host: ldap_host)
  filter          = Net::LDAP::Filter.eq(filter_name, filter_value)
  ldap_connection.search(base: ldap_treebase, filter: filter)  
end

def CleanLDAPvalue(val)
  return nil if val.nil?
  if val.kind_of?(Array)
    return nil if val.length == 0
    val = CleanLDAPvalue(val[0])
  else
    val.gsub(/[\n-\[\]]*/,"").strip
  end
  return val
end

def CleanLDAPrecord(rec)
  # results are a hash
  rec.each  do |key, value| 
     rec[key] = CleanLDAPvalue(rec[key]) 
  end
  return rec
end

def AddToLDAPrecord(rec, keys, defaultval=nil)
  # results are a hash
  reckeys = Array.new
  rec.each { |x,y| reckeys << x.to_s.downcase }
  keys.each  do |key| 
     rec[key] = defaultval  if !reckeys.include?(key.downcase)
  end
  return rec
end

# may need to adapt the ldap attributes to the Investigator data model
def BuildPIobject(pi_data)
  if pi_data.nil?
    raise_error "BuildPIobject: this shouldn't happen - pi_data was nil"
  end
  thePI = nil
  thePI = User.where(username: pi_data.uid).first
  begin 
    if thePI.nil?
      thePI = User.new(
        :username    =>  CleanLDAPvalue(pi_data["uid"]), 
        :last_name   => CleanLDAPvalue(pi_data["sn"]),
        :middle_name => ((CleanLDAPvalue(pi_data["displayname"]).split(" ").length > 2) ? pi_data["displayname"].split(" ")[1] : pi_data["numiddlename"]),
        :first_name  => CleanLDAPvalue(pi_data["givenName"]),
        :email       => CleanLDAPvalue(pi_data["mail"])
        )
    end
  rescue ActiveRecord::RecordInvalid => error
    log_message("BuildPIobject: raised an error for an investigator with the id of '#{pi_data.uid} with an error of #{error.inspect}")
    raise_error("BuildPIobject: unable to find or insert investigator with the id of '#{pi_data.uid}") if thePI.nil?
  end 
  thePI
end

def raise_error(msg)
  log_message(msg)
  raise msg
end

def log_message(msg)
  puts msg
  Rails.logger.error("ldap_utilities: #{msg}")
end

def MergePIrecords(thePI, pi_data)
  # trust LDAP
  if !pi_data.blank?
    thePI.title          = CleanLDAPvalue(pi_data["title"]) || thePI.title
    thePI.business_phone = CleanLDAPvalue(pi_data["telephoneNumber"]) || thePI.business_phone
    thePI.employee_id    = CleanLDAPvalue(pi_data["employeeNumber"]) || thePI.employee_id
    thePI.campus_address = CleanLDAPvalue(pi_data["postalAddress"]) || thePI.campus_address
    thePI.campus_address = thePI.campus_address.split("$").join(13.chr) if !  thePI.campus_address.blank?
    thePI.campus         = CleanLDAPvalue(pi_data["postalAddress"]).split("$").last || thePI.campus if ! pi_data["postalAddress"].blank?

    # home_department is no longer a string
    thePI["primary_department"] = CleanLDAPvalue(pi_data.ou)  if pi_data.ou !~ /People/
    # trust the internal system first
    thePI.email ||= CleanLDAPvalue(pi_data["mail"])
    thePI.fax   ||= CleanLDAPvalue(pi_data["facsimiletelephonenumber"])

    thePI = cleanup_campus(thePI)
  end
  thePI
end

def CleanPIfromLDAP(pi_data)
  if pi_data.length > 0 then
    clean_rec = CleanLDAPrecord(pi_data[0])
    clean_rec = AddToLDAPrecord(clean_rec, ["nuMiddleName","employeeNumber","sn","uid","givenName","title","telephoneNumber","postalAddress","mail","facsimiletelephonenumber"])
    clean_rec = AddToLDAPrecord(clean_rec, ["ou"], "" )
    return clean_rec
  end
  pi_data
end

def MakePIfromLDAP(pi_data)
  if pi_data.length > 0 then
    rec = CleanPIfromLDAP(pi_data)
    pi  = BuildPIobject(rec)
    pi  = MergePIrecords(pi, rec)
    begin
      logger.info "MakePIfromLDAP: #{pi.id} #{pi.username} #{pi.last_name} #{pi.first_name}"
    rescue Exception => error
      log_message "#{pi.id} #{pi.username} #{pi.last_name} #{pi.first_name}"
      log_message pi_data.inspect
      log_message pi.inspect
    end
    pi
  end
end

# may need to adapt the ldap attributes to the Investigator data model
def CreateOrUpdatePI(pi)
  log_message "CreateOrUpdatePI: this shouldn't happen - thePI was nil" if pi.nil?
  begin 
    pi.save!
  rescue ActiveRecord::RecordInvalid => error
    log_message "CreateOrUpdatePI: raised an error for an investigator with the id of '#{pi.username} with an error of #{error.inspect}"
  end 
  pi
end

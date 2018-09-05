class LdapUser < User

  devise :ldap_authenticatable, :rememberable, :timeoutable, :trackable
   
  # Callbacks
  before_save :ldap_before_save


  def ldap_before_save
    user_record           = Devise::LDAP::Adapter.get_ldap_entry(self.username)
    self.hydrate_from_ldap(user_record)
  end

  def hydrate_from_ldap(ldap_record)  
    self.username         = ldap_record[:uid].first
    self.email            = ldap_record[:mail].first
    self.first_name       = ldap_record[:givenName].first 
    self.last_name        = ldap_record[:sn].first 
    self.middle_name      = ldap_record[:nuMiddleName].first
    self.title            = ldap_record[:title].first
    self.business_phone   = ldap_record[:telephonenumber].first
    
    address_split         = ldap_record[:postaladdress].first.split('$')
    self.campus           = address_split.last
    self.campus_address   = address_split[0...-1].join("\n")
  end
end

class LdapUser < User

  devise :ldap_authenticatable, :rememberable, :timeoutable, :trackable
   
  # Callbacks
  before_save :ldap_before_save


  def ldap_before_save
    user_record = Devise::LDAP::Adapter.get_ldap_entry(self.username)
    self.username = user_record[:nuidtag].first
    self.username         = user_record[:nuidtag].first
    self.email            = user_record[:mail].first
    self.first_name       = user_record[:givenName].first 
    self.last_name        = user_record[:sn].first 
    self.middle_name      = user_record[:nuMiddleName].first
    self.title            = user_record[:title].first
    self.business_phone   = user_record[:telephonenumber].first
    
    address_split         = user_record[:postaladdress].first.split('$')
    self.campus           = address_split.last
    self.campus_address   = address_split[0...-1].join("\n")
  end
end

# -*- coding: utf-8 -*-
module SponsorsHelper
  def link_to_contact(user)
    link_to user.name, contact_sponsor_url(user)
  end
end

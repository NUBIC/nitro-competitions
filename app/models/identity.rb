# == Schema Information
#
# Table name: identities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  # TODO: change method name to find_or_create 
  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end

  ##
  # Known domains for northwestern
  # TODO: include RIC and Lurie when integrated into NM - 'ric', 'lurie_childrens'
  # @return [Array<String>]
  def self.northwestern_domains
    %w(nu nmh nmff-net)
  end

  ##
  # Known external authentication providers
  # @return [Array<Symbol>]
  def self.external_providers
    [ :facebook,
      :google,
      # :yahoo,
      :twitter,
      :linkedin
    ]
  end
end

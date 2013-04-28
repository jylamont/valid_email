require 'mail'
require 'resolv'

module ValidEmail
  class Email
    def self.valid?(value)
      m = Mail::Address.new(value)
      # We must check that value contains a domain and that value is an email address
      r = m.domain && m.address == value
      t = m.__send__(:tree)
      # We need to dig into treetop
      # A valid domain must have dot_atom_text elements size > 1
      # user@localhost is excluded
      # treetop must respond to domain
      # We exclude valid email values like <user@localhost.com>
      # Hence we use m.__send__(tree).domain
      r && (t.domain.dot_atom_text.elements.size > 1)
    rescue
      false
    end

    def self.mx_valid?(value)
      m = Mail::Address.new(value)
      mx = []
      Resolv::DNS.open do |dns|
        mx.concat dns.getresources(m.domain, Resolv::DNS::Resource::IN::MX)
      end
      mx.size > 0
    rescue
      false
    end
  end
end
require "virtus"
require "savon"
require "active_support/core_ext/hash/slice"
require "active_support/core_ext/object/blank"
require "soap_client/version"
require "soap_client/client"
require "soap_client/services/build_savon_attrs"

module SOAPClient

  def self.new(opts)
    Client.new(opts)
  end

  def self.call(opts)
    self.new(opts).()
  end

end

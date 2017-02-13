module SOAPClient
  class Client

    include Virtus.model

    attribute :action, Symbol
    attribute :message, Hash
    attribute :wsdl, String
    attribute :logger
    attribute :log, Boolean, default: false
    attribute :proxy, String
    attribute :open_timeout, Integer
    attribute :read_timeout, Integer

    def self.call(*args)
      self.new(*args).()
    end

    def call
      savon_client.call(action, message: message)
    end

    private

    def savon_client
      @savon_client ||= Savon.client(savon_attrs)
    end

    def savon_attrs
      BuildSavonAttrs.(attributes)
    end

  end
end

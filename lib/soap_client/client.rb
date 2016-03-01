module SOAPClient
  class Client

    include Virtus.model

    attribute :action, Symbol
    attribute :message, Hash
    attribute :wsdl, String
    attribute :logger
    attribute :log, Boolean, default: false
    attribute :proxy, String

    def self.call(*args)
      self.new(*args).()
    end

    def call
      savon_client.call(action, message: message)
    end

    private

    def savon_client
      @savon_client ||= Savon.client(savon_attributes)
    end

    def savon_attributes
      attrs = attributes.slice(
        :wsdl,
        :log,
        :logger,
      )
      attrs[:proxy] = proxy if proxy.present?
      attrs
    end

  end
end

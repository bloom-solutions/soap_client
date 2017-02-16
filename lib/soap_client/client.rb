module SOAPClient
  class Client

    include Virtus.model

    attribute :action, Symbol
    attribute :message, Hash
    attribute :wsdl, String
    attribute :logger, Object, lazy: true, default: :default_logger
    attribute :log, Boolean, default: false
    attribute :proxy, String
    attribute :open_timeout, Integer
    attribute :read_timeout, Integer
    attribute :scrub, Array[Hash]

    def self.call(*args)
      self.new(*args).()
    end

    def call
      if log
        LogXML.(logger, soap_request.body, soap_response.xml, scrub)
      end

      soap_response
    end

    private

    def soap_request
      @soap_request ||= soap_client.build_request(action, message: message)
    end

    def soap_response
      @soap_response ||= soap_client.(action, message: message)
    end

    def soap_client
      @soap_client ||= Savon.client(savon_attrs)
    end

    def savon_attrs
      BuildSavonAttrs.(attributes)
    end

    def default_logger
      Logger.new(STDOUT)
    end

  end
end

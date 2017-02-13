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

    def self.call(*args)
      self.new(*args).()
    end

    def call
      if log
        savon_request = savon_client.build_request(action, message: message)
        logger.info "Request XML: #{savon_request.body}"
      end

      savon_response = savon_client.call(action, message: message)

      logger.info("Response XML: #{savon_response.xml}") if log

      savon_response
    end

    private

    def savon_client
      @savon_client ||= Savon.client(savon_attrs)
    end

    def savon_attrs
      BuildSavonAttrs.(attributes)
    end

    def default_logger
      Logger.new(STDOUT)
    end

  end
end

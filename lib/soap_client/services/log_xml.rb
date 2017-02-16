module SOAPClient
  class LogXML

    def self.call(*args)
      self.new(*args).()
    end

    def initialize(logger, request_xml, response_xml, scrub_directives)
      @logger = logger
      @request_xml = request_xml
      @response_xml = response_xml
      @scrub_directives = scrub_directives
    end

    def call
      @logger.info(log_text)
    end

    private

    def log_text
      [
        "Request XML: #{scrubbed_request_xml}",
        "Response XML: #{scrubbed_response_xml}",
      ].join("\n")
    end

    def scrubbed_request_xml
      @scrubbed_request_xml ||= XMLScrubber.(@request_xml, @scrub_directives)
    end

    def scrubbed_response_xml
      @scrubbed_response_xml ||= XMLScrubber.(@response_xml, @scrub_directives)
    end

  end
end

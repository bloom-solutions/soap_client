module SOAPClient
  class LogXML

    def self.call(*args)
      self.new(*args).()
    end

    def initialize(logger, xml, scrub_directives)
      @logger = logger
      @xml = xml
      @scrub_directives = scrub_directives
    end

    def call
      @logger.info(scrubbed_xml)
    end

    private

    def scrubbed_xml
      @scrubbed_xml ||= XMLScrubber.(@xml, @scrub_directives)
    end

  end
end

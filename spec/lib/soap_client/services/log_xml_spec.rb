require 'spec_helper'

module SOAPClient
  RSpec.describe LogXML do

    let(:logger) { Logger.new(STDOUT) }
    let(:raw_request_xml) { "<xml type='request' raw='true'/>" }
    let(:scrubbed_request_xml) { "<xml type='request' raw='false'/>" }
    let(:raw_response_xml) { "<xml type='response' raw='true'/>" }
    let(:scrubbed_response_xml) { "<xml type='response' raw='false'/>" }
    let(:scrub_directives) { {name: {matches: "x:password"}} }

    before do
      allow(XMLScrubber).to receive(:call).
        with(raw_request_xml, scrub_directives).
        and_return(scrubbed_request_xml)

      allow(XMLScrubber).to receive(:call).
        with(raw_response_xml, scrub_directives).
        and_return(scrubbed_response_xml)
    end

    let(:log_text) do
      [
        "Request XML: #{scrubbed_request_xml}",
        "Response XML: #{scrubbed_response_xml}",
      ].join("\n")
    end

    it "logs the request and response XMLs, after cleaning them" do
      expect(logger).to receive(:info).with(log_text)
      described_class.
        (logger, raw_request_xml, raw_response_xml, scrub_directives)
    end

  end
end

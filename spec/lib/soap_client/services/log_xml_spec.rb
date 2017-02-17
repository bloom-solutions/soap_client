require 'spec_helper'

module SOAPClient
  RSpec.describe LogXML do

    let(:logger) { Logger.new(STDOUT) }
    let(:raw_xml) { "<xml raw='true'/>" }
    let(:scrubbed_xml) { "<xml raw='false'/>" }
    let(:scrub_directives) { {name: {matches: "x:password"}} }

    before do
      allow(XMLScrubber).to receive(:call).
        with(raw_xml, scrub_directives).
        and_return(scrubbed_xml)
    end

    it "logs the request and response XMLs, after cleaning them" do
      expect(logger).to receive(:info).with(scrubbed_xml)
      described_class.(logger, raw_xml, scrub_directives)
    end

  end
end

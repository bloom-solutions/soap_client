require 'spec_helper'

module SOAPClient
  RSpec.describe BuildSavonAttrs do

    let(:logger) { double }
    let(:result) { described_class.(attrs) }

    context "proxy is not present" do
      let(:attrs) { { wsdl: "wsdl", log: true, logger: logger, proxy: nil } }

      it "returns the wsdl, log, and logger keypairs" do
        expect(result).to eq({wsdl: "wsdl", log: false})
      end
    end

    context "proxy is present" do
      let(:proxy) { double }
      let(:attrs) { { wsdl: "wsdl", log: true, logger: logger, proxy: proxy } }

      it "returns the wsdl, log, logger, and proxy keypairs" do
        expect(result).to eq({wsdl: "wsdl", log: false, proxy: proxy})
      end
    end

    context "log is true" do
      let(:attrs) { {log: true} }

      # Do not let savon log the XMLs - we should be the ones to scrub it and
      # log it ourselves
      it "always sets log to false" do
        expect(result[:log]).to be false
      end
    end

  end
end

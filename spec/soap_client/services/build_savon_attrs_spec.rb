require 'spec_helper'

module SOAPClient
  RSpec.describe BuildSavonAttrs do

    let(:logger) { double }
    let(:result) { described_class.(attrs) }

    context "proxy is not present" do
      let(:attrs) { { wsdl: "wsdl", log: true, logger: logger, proxy: nil } }

      it "returns the wsdl, log, and logger keypairs" do
        expect(result).to eq({ wsdl: "wsdl", log: true, logger: logger })
      end
    end

    context "proxy is present" do
      let(:proxy) { double }
      let(:attrs) { { wsdl: "wsdl", log: true, logger: logger, proxy: proxy } }

      it "returns the wsdl, log, logger, and proxy keypairs" do
        expect(result).
          to eq({ wsdl: "wsdl", log: true, logger: logger, proxy: proxy })
      end
    end

  end
end

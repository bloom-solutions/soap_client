require 'spec_helper'

describe SOAPClient do

  it 'has a version number' do
    expect(SOAPClient::VERSION).not_to be nil
  end

  describe ".new" do
    it 'instantiates a SOAPClient::Client' do
      logger = Object.new
      client = described_class.new(
        action: "disburse",
        message: {param: "1"},
        wsdl: "https://domain.com?WSDL",
        logger: logger,
        log: true,
        proxy: "https://proxy.com",
      )

      expect(client).to be_an_instance_of(SOAPClient::Client)
      expect(client.action).to eq :disburse
      expect(client.message).to eq({param: "1"})
      expect(client.wsdl).to eq "https://domain.com?WSDL"
      expect(client.logger).to eq logger
      expect(client.log).to eq true
      expect(client.proxy).to eq "https://proxy.com"
    end
  end

  describe ".call" do
    let(:client) { SOAPClient::Client.new }
    let(:opts) { {action: :disburse} }
    let(:response) { double }
    it "delegates work to an instance of the client" do
      expect(SOAPClient::Client).to receive(:new).with(opts).
        and_return(client)
      expect(client).to receive(:call).and_return(response)

      expect(described_class.(opts)).to eq response
    end
  end

end

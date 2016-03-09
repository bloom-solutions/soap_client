require 'spec_helper'

module SOAPClient
  describe Client, type: [:virtus] do

    describe "attributes" do
      subject { described_class }
      it { is_expected.to have_attribute(:action, Symbol) }
      it { is_expected.to have_attribute(:message, Hash) }
      it { is_expected.to have_attribute(:wsdl, String) }
      it { is_expected.to have_attribute(:log) }
      it { is_expected.to have_attribute(:logger) }
      it { is_expected.to have_attribute(:proxy, String) }
      it { is_expected.to have_attribute(:read_timeout, Integer) }
      it { is_expected.to have_attribute(:open_timeout, Integer) }
    end

    describe ".call" do
      let(:client) { instance_double(described_class) }
      it "instantiates a client and calls `call`" do
        expect(described_class).to receive(:new).with("args").
          and_return(client)
        expect(client).to receive(:call)
        described_class.("args")
      end
    end

    describe "#call" do
      let(:savon_client) { double }
      let(:soap_response) { double(:soap_response) }

      it "makes a call using savon" do
        client = described_class.new({
          action: :action,
          proxy: "something.com",
          message: {great: "success"},
        })

        expect(Savon).to receive(:client).
          with(client.attributes.slice(:wsdl, :log, :logger, :proxy)).
          and_return(savon_client)

        expect(savon_client).to receive(:call).
          with(client.action, message: client.message).
          and_return(soap_response)

        response = client.()

        expect(response).to eq(soap_response)
      end

      context "proxy is blank" do
        it "does not set the proxy" do
          client = described_class.new({
            action: :action,
            message: {great: "success"},
          })

          expect(Savon).to receive(:client).
            with(client.attributes.slice(:wsdl, :log, :logger)).
            and_return(savon_client)

          expect(savon_client).to receive(:call).
            with(client.action, message: client.message).
            and_return(soap_response)

          response = client.()

          expect(response).to eq(soap_response)
        end
      end
    end

  end
end


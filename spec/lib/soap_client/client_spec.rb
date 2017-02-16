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
      let(:savon_response) do
        instance_double(Savon::Response, xml: "<xml response='true'/>")
      end

      it "makes a call using savon" do
        client = described_class.new({
          action: :action,
          proxy: "something.com",
          message: {great: "success"},
        })

        expect(BuildSavonAttrs).to receive(:call).with(client.attributes).
          and_return({attr: 1})

        expect(Savon).to receive(:client).with(attr: 1).and_return(savon_client)

        expect(savon_client).to receive(:call).
          with(client.action, message: client.message).
          and_return(savon_response)

        response = client.()

        expect(response).to eq(savon_response)
      end

      context "logging is turned on" do
        let(:client) do
          described_class.new({
            action: :action,
            proxy: "something.com",
            message: {great: "success"},
            logger: logger,
            log: true,
          })
        end
        let(:logger) { double }
        let(:savon_request) do
          instance_double(HTTPI::Request, body: "<xml request='true'/>")
        end

        before do
          allow(BuildSavonAttrs).to receive(:call).with(client.attributes).
            and_return({attr: 1})
        end

        it "makes a call using savon and logs request and response" do
          expect(Savon).to receive(:client).with(attr: 1).
            and_return(savon_client)

          expect(savon_client).to receive(:build_request).
            and_return(savon_request)

          expect(logger).to receive(:info).
            with("Request XML: #{savon_request.body}")

          expect(savon_client).to receive(:call).
            with(client.action, message: client.message).
            and_return(savon_response)

          expect(logger).to receive(:info).
            with("Response XML: #{savon_response.xml}")

          response = client.()

          expect(response).to eq(savon_response)
        end
      end
    end

  end
end


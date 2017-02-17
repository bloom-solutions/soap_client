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
      it { is_expected.to have_attribute(:scrub, Array[Hash]) }
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
      let(:soap_response) do
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
          and_return(soap_response)

        response = client.()

        expect(response).to eq(soap_response)
      end

      context "logging is turned on" do
        let(:client) do
          described_class.new({
            action: :action,
            proxy: "something.com",
            message: {great: "success"},
            logger: logger,
            log: true,
            scrub: scrub_directives,
          })
        end
        let(:scrub_directives) do
          [{name: {matches: "pass"}}, {name: {matches: /secret/i}}]
        end
        let(:logger) { double }
        let(:soap_request) do
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
            and_return(soap_request)

          expect(savon_client).to receive(:call).
            with(client.action, message: client.message).
            and_return(soap_response)

          expect(LogXML).to receive(:call).
            with(logger, soap_request.body, scrub_directives)
          expect(LogXML).to receive(:call).
            with(logger, soap_response.xml, scrub_directives)

          response = client.()

          expect(response).to eq(soap_response)
        end
      end
    end

  end
end


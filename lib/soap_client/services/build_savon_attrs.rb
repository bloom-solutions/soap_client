module SOAPClient
  class BuildSavonAttrs

    def self.call(raw_attrs)
      attrs = raw_attrs.slice(
        :wsdl,
        :log,
        :logger,
      )
      attrs[:proxy] = raw_attrs[:proxy] if raw_attrs[:proxy].present?
      attrs
    end

  end
end

class Config
  class << self

    def api_version
      '1.0'.freeze
    end

    def host
      "test@example.com"
    end

    def partner_wsdl
      File.join(wsdl, 'partner.xml')
    end

    def metadata_wsdl
      File.join(wsdl, 'metadata.xml')
    end

    def endpoint
      "https://#{host}/services/Soap/u/#{api_version}"
    end

    def wsdl
      File.join(Rails.root, 'wsdl')
    end
  end
end

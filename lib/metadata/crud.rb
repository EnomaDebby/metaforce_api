module Metadata
  class Update
    def initialize(options)
      @options = options
    end

    def update
      new_client.call(:update_metadata,
                      message: {customField: encoded_data(metadata),
                                attributes!: {
                                  customField: {
                                    "xsi:type" => "ins0:CustomField"
                                  }
                                }})
    end

    private

    def new_client
      Savon.client do |globals|
        globals.wsdl Config.metadata_wsdl
        globals.endpoint @options[:metadata_server_url]
        globals.ssl_verify_mode :none
        globals.soap_header soap_headers
        globals.namespace_identifier :ins0
      end
    end

    def soap_headers
      {'ins0:SessionHeader' => {'ins0:sessionId' => session_id}}
    end

    def session_id
      @options[:session_id]
    end

    def encoded_data(metadata)
      metadata = [metadata].compact.flatten
      metadata.each {|m| encode_content(m)}
      metadata
    end

    def encode_content(metadata)
      metadata[:content] = Base64.encode64(metadata[:content]) if metadata.has_key?(:content)
    end
  end
end
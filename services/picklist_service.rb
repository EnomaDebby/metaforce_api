class PicklistService
  def initialize(object, fields)
    @object = object
    @fields = fields
  end

  attr_reader :object, :fields

  def update_picklist
    authenticate! unless session_id
    retries = authentication_retries

    begin
      response = update_data
      alert_if_unsuccessful(response)
    rescue ::Savon::SOAPFault => e
      if e.message =~ /INVALID_SESSION_ID/ && retries.positive?
        login!
        retries -= 1
        retry
      end
      raise
    end
  end

  private

  def authenticate!
    Login.new("test", "password", options).authenticate
  end

  def update_data
    Metadata::Crud.new(metadata).update
  end

  def metadata
    {
      fullName: object,
      type: 'MultiselectPicklist',
      label: label,
      visible_lines: 4,
      value_set: {restricted: true,
                  value_set_definition: { value: fields_array }}
    }
  end

  def authentication_retries
    3
  end

  def fields_array
    fields.map {|field| {full_name: field, default: false, is_active: true}}
  end

  def session_id
    options[:session_id]
  end

  def options
    {}
  end

  def alert_if_unsuccessful(response)
    successful = response.body.dig(:update_metadata_response, :result, :success)
    if successful
      successful
    else
      error = response.body.dig(:update_metadata_response, :result, :errors, :message)
      AlertService.call(error)
    end
  end
end


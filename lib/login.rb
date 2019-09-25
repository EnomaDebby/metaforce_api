class Login
  def initialize(username, password, options)
    @username, @password, @options = username, password, options
  end

  attr_reader :username, :password, :options

  def authenticate
    message = {username: username, password: password}
    response = client.call(:login, message: message)
    options.merge!(response.body[:login_response][:result])
  end

  private

  def client
    @client ||= Savon.client do
      endpoint Config.endpoint
      wsdl Config.partner_wsdl
    end
  end
end
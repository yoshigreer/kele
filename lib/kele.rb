require 'httparty'

class Kele
  include HTTParty

  def initialize(username, password)
    response = self.class.post("https://www.bloc.io/api/v1/sessions", body: { "email": username, "password": password })
    @auth_token = response["auth_token"]
    raise "invalid entry" if @auth_token.nil?
  end
end

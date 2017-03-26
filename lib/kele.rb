require 'httparty'
require 'json'

class Kele
  include HTTParty

  def initialize(username, password)
    response = self.class.post("https://www.bloc.io/api/v1/sessions", body: { "email": username, "password": password })
    @auth_token = response["auth_token"]
    raise "invalid entry" if @auth_token.nil?
  end

  def get_me
    response = self.class.get("https://www.bloc.io/api/v1/users/me", headers: { "authorization" => @auth_token })
    @user = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end
end

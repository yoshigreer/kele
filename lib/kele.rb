require 'httparty'
require 'json'
require 'roadmap'

class Kele
  include HTTParty
  include Roadmap

  def initialize(username, password)
    response = self.class.post(api_url("sessions"), body: { "email": username, "password": password })
    @auth_token = response["auth_token"]
    raise "invalid entry" if @auth_token.nil?
  end

  def get_me
    response = self.class.get(api_url("users/me"), headers: { "authorization" => @auth_token })
    @user = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(api_url("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end

=begin
  def get_roadmap(roadmap_id)
    response = self.class.get(api_url("roadmaps/#{roadmap_id}"), headers: { "authorization" => @auth_token })
    @roadmap = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = self.class.get(api_url("checkpoints/#{checkpoint_id}"), headers: { "authorization" => @auth_token })
    @checkpoint = JSON.parse(response.body)
  end
=end

  def get_messages(page = nil)
    if page == nil
      response = self.class.get(api_url("message_threads"), headers: { "authorization" => @auth_token })
    else
      response = self.class.get(api_url("message_threads"), headers: { "authorization" => @auth_token }, body: { page: page })
    end
    @messages = JSON.parse(response.body)
  end

  def send_message(sender, recipient_id, subject, stripped_text)
    response = self.class.post(api_url("messages"), headers: { "authorization" => @auth_token }, body: { sender: sender, recipient_id: recipient_id, subject: subject, stripped_text: stripped_text })
  end

  def api_url(end_point)
    "https://www.bloc.io/api/v1/#{end_point}"
    # "https://private-anon-6b17356c10-blocapi.apiary-mock.com/api/v1/#{end_point}"
  end
end

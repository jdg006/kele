require 'httparty'
require_relative "roadmap.rb"

class Kele
  
include Roadmap
include HTTParty

  def initialize (email, password)
     @bloc_base_api_url = 'https://www.bloc.io/api/v1'
     response = self.class.post('https://www.bloc.io/api/v1/sessions', body: {"email": email, "password": password})
     @auth_token = response["auth_token"]
     if @auth_token == nil
        puts "incorrect username or password"
     end
  end
  
  def get_me
      response = self.class.get('https://www.bloc.io/api/v1/users/me', headers: { "authorization" => @auth_token })
      JSON.parse(response.body)
  end

  def get_mentor_availability
       mentor_id = self.get_me["current_enrollment"]["mentor_id"]
       response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
       JSON.parse(response.body)
  end
  
  def get_messages(page_number = 0)
      
      if page_number == 0
        
        all_pages = []
        response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization" => @auth_token })
        message_count = JSON.parse(response.body)["count"]
        page_count = message_count/10
        
        if message_count % 10 > 0
           page_count += 1
        end
        
        i = 1
        while i <= page_count do
          all_pages.push(JSON.parse(self.class.get("https://www.bloc.io/api/v1/message_threads", body: {"page": i,}, headers: { "authorization" => @auth_token }).body))
          i += 1
        end
        return all_pages
        
      else
        response = self.class.get("https://www.bloc.io/api/v1/message_threads", body: {"page": page_number,}, headers: { "authorization" => @auth_token })
          return JSON.parse(response.body)
      end
      
  end
  
  def create_message(message, recipient_id, subject, thread_token = nil)
    if thread_token == nil
      self.class.post("https://www.bloc.io/api/v1/messages", body: {
      "sender": "jdg006@lvc.edu",
      "recipient_id": recipient_id,
      "subject": subject,
      "stripped-text": message},
      headers: { "authorization" => @auth_token })
    else
      self.class.post("https://www.bloc.io/api/v1/messages", body: {
      "sender": "jdg006@lvc.edu",
      "recipient_id": recipient_id,
      "token": thread_token,
      "subject": subject,
      "stripped-text": message},
      headers: { "authorization" => @auth_token })
    end
  end
  
  
end


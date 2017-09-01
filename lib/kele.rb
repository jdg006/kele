require 'httparty'
require_relative "roadmap.rb"

class Kele
  
include Roadmap
include HTTParty

  def initialize (email, password)
     body = {"email": email, "password": password}
     @base_api_url = 'https://www.bloc.io/api/v1'
     @auth_token = self.class.post(@base_api_url + '/sessions', body: body)["auth_token"]
     @headers = { "authorization" => @auth_token }
     
     if @auth_token == nil
        puts "incorrect username or password"
     end
     
  end
  
  def get_me
      JSON.parse(self.class.get(@base_api_url + '/users/me', headers: @headers).body)
  end

  def get_mentor_availability
       mentor_id = self.get_me["current_enrollment"]["mentor_id"]
       JSON.parse(self.class.get(@base_api_url + "/mentors/#{mentor_id}/student_availability", headers: @headers).body)
  end
  
  def get_messages(page_number = 0)
      
      if page_number == 0
        
        all_pages = []
        response = self.class.get(@base_api_url + "/message_threads", headers: @headers)
        message_count = JSON.parse(response.body)["count"]
        page_count = message_count/10
        
        if message_count % 10 > 0
           page_count += 1
        end
        
        i = 1
        while i <= page_count do
          all_pages.push(JSON.parse(self.class.get(@base_api_url + "/message_threads", body: {"page": i,}, headers: @headers).body))
          i += 1
        end
        return all_pages
        
      else
          return JSON.parse(self.class.get(@base_api_url + "/message_threads", body: {"page": page_number,}, headers: @headers).body)
      end
      
  end
  
  def create_message(message, recipient_id, subject, thread_token = nil)
    if thread_token == nil
      self.class.post(@base_api_url + "/messages", body: {
      "sender": "jdg006@lvc.edu",
      "recipient_id": recipient_id,
      "subject": subject,
      "stripped-text": message},
      headers: @headers)
    else
      self.class.post(@base_api_url + "/messages", body: {
      "sender": "jdg006@lvc.edu",
      "recipient_id": recipient_id,
      "token": thread_token,
      "subject": subject,
      "stripped-text": message},
      headers: @headers)
    end
  end
  
  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    body = {
    "assignment_branch": assignment_branch,
    "assignment_commit_link": assignment_commit_link,
    "checkpoint_id": checkpoint_id, #1905
    "comment": comment,
    "enrollment_id":28188}
    
    self.class.post(@base_api_url + "/checkpoint_submissions", body: body, headers: @headers)
    
  end
end


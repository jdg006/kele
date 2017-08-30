require 'httparty'

class Kele

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
  
end


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

end

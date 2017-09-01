module Roadmap
   
  def get_roadmap(roadmap_id)
      JSON.parse(self.class.get(@base_api_url + "/roadmaps/#{roadmap_id}", headers: @headers).body)
  end
  
  def get_checkpoint(checkpoint_id)
      JSON.parse(self.class.get(@base_api_url + "/checkpoints/#{checkpoint_id}", headers: @headers).body)
  end
  
end
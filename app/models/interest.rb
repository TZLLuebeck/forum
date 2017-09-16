class Interest < ApplicationRecord

  acts_as_taggable_on :tags

  belongs_to :user

  #after_save :find_similar_interests

  def find_similar_interests
    ownerid = User.find(self.user_id).id
    id = self.id
    MatchmakingWorker.perform_async(id, ownerid)
  end 
end
class User < ActiveRecord::Base
  validates :uid, :provider, :username, :email, presence: true
  has_many :vets

  def self.find_or_create_from_omniauth(auth_hash)
   user = self.find_by(uid: auth_hash["uid"], provider: auth_hash["provider"])
   if !user.nil?
     return user
   elsif auth_hash["provider"] == "google"
     user            = User.new
     user.uid        = auth_hash["uid"]
     user.provider   = auth_hash["provider"]
     user.username   = auth_hash["info"]["name"]
     user.email      = auth_hash["info"]["email"]
     user.image      = auth_hash["info"]["image"]
     if user.save
       return user
     else
       return nil
     end
   end
  end
end

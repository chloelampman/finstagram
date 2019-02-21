#< is inheritance, ActiveRecord::base has database interaction functionality
class User < ActiveRecord::Base
    
    has_many :finstagram_posts
    has_many :comments
    has_many :likes
    
    def post_count
        self.finstagram_posts.count
    end
    
    # need these to be unique to create a user object
    validates :email, :username, uniqueness: true
    
    #need all these to be present to create a user object
    validates :email, :avatar_url, :username, :password, presence: true

end
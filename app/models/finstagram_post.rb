#ActiveRecord actually looks for a table named the plural (snake_case) of the class name, so we NEED the table to be called finstagram_posts
class FinstagramPost < ActiveRecord::Base
    
    belongs_to :user
    has_many :likes
    has_many :comments
    
    #FinstagramPost record cannot be created if it does not have a User record associated with it
    #not just a user_id, but an actual user record
    #need a photo to create a post object
    validates :photo_url, :user, presence: true

    
    def like_count
        self.likes.size
    end
    
    def comment_count
        self.comments.size
    end

    def humanized_time_ago
        time_ago_in_seconds = Time.now - self.created_at
        time_ago_in_minutes = time_ago_in_seconds / 60
        time_ago_in_hours = time_ago_in_minutes / 60
        time_ago_in_days = time_ago_in_hours / 24
        
        if time_ago_in_days >= 1
            "#{time_ago_in_days.to_i} days ago"
        elsif time_ago_in_hours >= 1
            "#{time_ago_in_hours.to_i} hours ago"
        elsif time_ago_in_minutes >= 5 
            "#{time_ago_in_minutes.to_i} minutes ago"
        else
            "Just now"
        end
    end
end
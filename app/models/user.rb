class User < ActiveRecord::Base
  has_and_belongs_to_many :games
  has_many :elo_changes

  has_secure_password

  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }

 def recent_rating_change
   total_change = 0
   User.find(id).elo_changes.last(5).each do |elo_change|
     total_change += elo_change.change
   end
   total_change > 0 ? total_change = "+" + total_change.to_s : total_change = total_change.to_s
   return total_change
 end

 def chart_rating_change
   rating = 0
   user = User.find(id)
   chart_change = []
   user.elo_changes.each do |elo_change|
     rating += elo_change.change
     chart_change << rating
   end
   return chart_change
 end

end

class User < ActiveRecord::Base
  has_and_belongs_to_many :games
  has_many :elo_changes

  has_secure_password

  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }

  def recent_rating_change
    total_change = 0
    User.find(id).elo_changes.last(2).each do |elo_change|
      total_change += elo_change.change
      puts elo_change.change
    end
    total_change > 0 ? total_change = "+" + total_change.to_s : total_change = "-" + total_change.to_s
    return total_change
  end

  def chart_rating_change
    rating = 0
    cr = current_rating
    user = User.find(id)
    chart_change = [cr]
    user.elo_changes.each do |elo_change|
      cr += elo_change.change
      chart_change << cr
    end
    binding.pry
    return chart_change
  end


end

class Movie < ActiveRecord::Base

def self.get_ratings
  ratings = self.select('rating as rating' ).group('rating')
  all_ratings = []
  ratings.each do  |rating|
    all_ratings << rating.rating
  end
  return all_ratings

end

end

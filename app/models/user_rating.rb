require 'descriptive_statistics' #so i can call built in mean and standard deviation methods

class UserRating < ApplicationRecord
	belongs_to :user

	def self.projected_rating(user, ratings, genres)
		count = 0
		projected = 0

		#the keys hash contains the keys to the 'ratings' argument, and the values are key's to  the genre_proj method which selects each sub differential from DB
		keys = {imdb: :imdb_dif, meta: :meta_dif, rt: :rt_dif}

		#iterates through each key value pair, and all the genres by calling the genre_proj method.
		keys.each do |key, value|
			puts ratings[key]
			if !ratings[key].nil? #checks to ensure that there is a critic rating from which to compare before running genre_proj
				projected += (UserRating.genre_proj(user, genres, value) + ratings[key])
				count += 1	
			end
		end


		if count > 0
			rating = projected / count
			if rating >= 10
				return 10.00
			else
				return rating.round(2)
			end
		else
			return 'There is not enough information for us to project a rating at this time'
		end
	end

	private
	
	def self.genre_proj(user, genres, key)
		scores = genres.map do |genre|
			user.user_ratings.where("genres LIKE ?", "%" +genre+ "%").last(30).pluck(key) #selects up to the last thirty movies the user rated of each genre of searched film
		end																																							
		scores.flatten!.compact! #flattens array and removes any nil values
		mean = scores.mean
		std_dev = scores.standard_deviation
		scores.map! { |e|  e if(mean.abs - e.abs).abs <=  std_dev }.compact! #removes data points that are outside the standard deviation to the mean, and removes nil elements
		return scores.mean
	end
end

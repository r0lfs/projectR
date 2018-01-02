require 'descriptive_statistics' #so i can call built in mean and standard deviation methods

class UserRating < ApplicationRecord
	belongs_to :user
	# validates 

	def self.projected_rating(user, ratings, genres)
		projected = []
		projected_dif = 0

		#the keys hash contains the keys to the 'ratings' argument, and the values are key's to  the genre_proj method which selects each sub differential from DB
		keys = {imdb: :imdb_dif, meta: :meta_dif, rt: :rt_dif, proj: :dif_projected}

		#iterates through each key value pair, and all the genres by calling the genre_proj method.
		keys.each do |key, value|
			if !ratings[key].nil? && key != :proj #checks to ensure that there is a critic rating from which to compare before running genre_proj
				crit_proj = (UserRating.genre_proj(user, genres, value))
				if !crit_proj.nil?
					projected<<(crit_proj + ratings[key])
				end
			elsif key == :proj
				projected_dif = UserRating.genre_proj(user, genres, value) #gets the average variance from projected an actual of past user rated films
				puts projected_dif
			end
		end

		#checks to make sure there is at least one projected element in array
		if projected.length > 0
			projected_rating = projected.mean 
			projected_rating += projected_dif/2 if !projected_dif.nil? 
			if projected_rating >= 10
				return 10.00
			else
				return projected_rating.round(2)
			end
		else
			return 'There is not enough information for us to project a rating at this time'
		end
	end

	private
	
	def self.genre_proj(user, genres, key)
		scores = genres.map do |genre|
			user.user_ratings.where("genres LIKE ?", "%" +genre+ "%").last(20).pluck(key) #selects up to the last twenty movies the user rated of each genre of searched film
		end

		if scores.flatten.compact.length == 0 #if there are no data points, return nil
			return nil																									
		else
			sample_mean = 0
			sample_size = 0

			#iterates through each sub array of genre values to weight score based on sample size of each array
			scores.each do |array|
				array.compact! 
				if array.length > 0
					mean = array.mean
					std_dev = array.standard_deviation
					array.map! { |e| e if e >= (mean - std_dev * 3)}.compact! #eliminates data points smaller than 3 std deviations below the mean
					array.map! { |e| e if e <= (mean + std_dev * 3)}.compact! #eliminates data points larger than 3 std deviations above the mean

					sample_size += array.length
					sample_mean += (array.mean * array.length)
				end
			end
			return (sample_mean / sample_size)
		end
	end

end

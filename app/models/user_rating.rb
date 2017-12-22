require 'descriptive_statistics'

class UserRating < ApplicationRecord
	belongs_to :user

	def self.projected_rating(user, ratings, genres)
		count = 0
		projected = 0

		if !ratings[:imdb].nil? #checks to ensure that there is a imdb rating to compare
			projected += (UserRating.imdb_proj(user, genres) + ratings[:imdb])
			count += 1	
		end

		if !ratings[:meta].nil?
			projected += (UserRating.meta_proj(user, genres) + ratings[:meta])
			count += 1
		end

		if !ratings[:rt].nil?
		  projected += (UserRating.rt_proj(user, genres) + ratings[:rt])
		  count += 1
		end

		if count > 0
			rating = projected / count
			if rating > 10
				return 10.0
			else
				return rating.round(2)
			end
		else
			return 'There is not enough information for us to project a rating at this time'
		end
	end

	private
	# i tried to keep this DRY, but I couldn't figure out how to pass in a symbol without it throwing an error
	def self.imdb_proj(user, genres)
		scores = genres.map do |genre|
			user.user_ratings.where("genres LIKE ?", "%" +genre+ "%").last(10).pluck(:imdb_dif) #selects the last ten movies the user rated including the genre of searched film
		end
		scores.flatten! #flattens array to single dimension 
		mean = scores.mean
		std_dev = scores.standard_deviation
		return (mean / std_dev) * mean #this is using the coefficent of variation to weight the score
	end

	def self.meta_proj(user, genres)
		scores = genres.map do |genre|
			user.user_ratings.where("genres LIKE ?", "%" +genre+ "%").last(10).pluck(:meta_dif)
		end
		scores.flatten!
		mean = scores.mean
		std_dev = scores.standard_deviation
		return (mean / std_dev) * mean #this is using the coefficent of variation to weight the score
		
	end

	def self.rt_proj(user, genres)
		scores = genres.map do |genre|
			user.user_ratings.where("genres LIKE ?", "%" +genre+ "%").last(10).pluck(:rt_dif)
		end
		scores.flatten!
		mean = scores.mean
		std_dev = scores.standard_deviation
		return (mean / std_dev) * mean #this is using the coefficent of variation to weight the score
	end
end

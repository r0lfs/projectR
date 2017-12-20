class UserRating < ApplicationRecord
	belongs_to :user

	def self.projected_rating(user, ratings, genres)
		scores = genres.map do |genre|
			user.user_ratings.where("genres LIKE ?", "%" +genre+ "%").last(10).pluck{:imdb_dif, :meta_dif, :rt_dif}
		end
		scores.flatten
	end
end

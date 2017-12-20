class UserRating < ApplicationRecord
	belongs_to :user

	def self.projected_rating()
end

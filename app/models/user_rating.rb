require 'descriptive_statistics'

class UserRating < ApplicationRecord
	belongs_to :user
	# validates 

	private

	#the projected_rating method's primary purpose is to loop the 4 projection attributes through the genre_proj method and return a projected rating
	#which is a weighted average of the projected rating of the 3 critic review scores (rotten tomatoes, imdb, metacritic) 
	#minus half of the average difference of past projections and actual user ratings
	def self.projected_rating(user, ratings, genres)

		projected = []
		projected_dif = 0

		#the keys hash contains the keys to the 'ratings' argument, and the values are key's to the genre_proj method which selects each sub differential from DB
		keys = {imdb: :imdb_dif, meta: :meta_dif, rt: :rt_dif, proj: :dif_projected}

		#iterates through each key value pair, and all the genres by calling the genre_proj method.
		keys.each do |key, value|
			if !ratings[key].nil? && key != :proj #checks to ensure that there is a critic rating from which to compare before running genre_proj
				crit_proj = (UserRating.genre_proj(user, genres, value))
				if !crit_proj.nil?
					projected<<(crit_proj + ratings[key]) #pushes the projected rating into array so mean of all projections can be called later
				end
			elsif key == :proj
				projected_dif = UserRating.genre_proj(user, genres, value) #gets the average variance from projected ratings and user rated films of already rated films
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
		elsif ratings[:meta].nil? && ratings[:imdb].nil? && ratings[:rt].nil?
			return 'There are not enough critic reviews for us to project a rating at this time'
		else
			return "You haven't rated enough films with these genres for us to give a projected rating for this film"
		end
	end #ends projected_rating

	#the genre_proj method takes in the user, genres array, and a projection attribute key. for each genre, it will pull the last twenty movies rated by the user
	#with that genre, and put them in a multidimensional array. if there are valid scores, it will then iterate through each sub array, remove extreme outliers
	#and return the weighted mean of the scores from each genre.
	def self.genre_proj(user, genres, key)

		scores = genres.map do |genre|                                                   
			user.user_ratings.where("genres LIKE ?", "%" +genre+ "%").last(20).pluck(key) 
		end  

		if scores.flatten.compact.length == 0 #if there are no data points at all, return nil
			return nil																									
		else
			sample_mean = 0
			sample_size = 0

			#iterates through each sub array of genre values to weight score based on sample size of each array
			scores.each do |array|
				array.compact! #removes all nil values from array
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
	end #ends genre_proj

	#because there is some math that has to be done when a user rates a film, a hash of the params from the form are passed into this method,
	#which calculates the values of the projection elements (rt_dif, imdb_dif, meta_dif, and dif_projected), and merges them into a hash
	#which already contains the required elements. it returns this hash, which is then used in the creation/updating of a UsereRating record.
	def self.create_params(params_hash)
		#basic required elements for UserRating record, plus defaults dif_projected to nil
		gnu_hash = {user_id: params_hash[:user_id], imdb_id: params_hash[:imdb_id], genres: params_hash[:genres], dif_projected: nil}

		critics = {imdb: :imdb_dif, meta: :meta_dif, rt: :rt_dif} #hash of keys with keys as values that allows their values to be set later

  	rating = params_hash[:rating].to_f #converts rating from form to float
  	gnu_hash.merge!(:rating => rating )

    if !params_hash[:proj].nil? #if film had a projected rating passed through params, note the difference between projected and user rating
      proj_dif = rating - params_hash[:proj].to_f
      gnu_hash.merge!( :dif_projected => proj_dif ) 
    end

    #iterates through critics hash, checks if there is a critic rating from params, and if there is, sets the value to difference between user & critic rating
    critics.each do |key, value|
    	if params_hash[key] != ""
    	 	crit_dif = (rating - params_hash[key].to_f)
    	 	gnu_hash.merge!(value => crit_dif)
    	else
        gnu_hash.merge!(value => nil)
      end
    end
    return gnu_hash
	end #ends create_params
end

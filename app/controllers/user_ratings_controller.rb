class UserRatingsController < ApplicationController
  def index
  end

  def new
    @user_rating = UserRating.new
  end

  def create
    critics = {imdb: nil, meta: nil, rt: nil} #hash of keys that allows values to be set later

  	rating = user_rating_params[:rating].to_f #converts rating from form to float

    if !user_rating_params[:proj].nil? #if film had a projected rating passed through params, note the difference between projected and user rating
      proj_dif = rating - user_rating_params[:proj].to_f 
    end

    #iterates through critics hash, checks if there is a critic rating from params, and if there is, sets the value to difference between user & critic rating
    critics.each do |key, value|
      puts "#{key}'s value is #{user_rating_params[key]}"
    	if (user_rating_params[key].to_f / 1) != 0.0
    	 	critics[key] = (rating - user_rating_params[key].to_f)
        puts "this difference is #{critics[key]}"
    	else
        critics[key] = nil
      end
    end

  	@user_rating = UserRating.new(user_id: current_user.id, imdb_id: user_rating_params[:imdb_id], genres: user_rating_params[:genres],
  	 	imdb_dif: critics[:imdb], meta_dif: critics[:meta], rt_dif: critics[:rt], rating: rating, dif_projected: (proj_dif if defined? proj_dif))
  	
  	if @user_rating.save
  		current_user.increment!(:rate_count)

  		respond_to do |format|
  			format.js
  		end
  	end
  end

  def update
  end

  def user_rating_params
    params.require(:movie).permit(:rating, :imdb, :meta, :rt, :imdb_id, :genres, :proj)
  end
end

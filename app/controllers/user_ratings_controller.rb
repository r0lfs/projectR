class UserRatingsController < ApplicationController
  def index
  end

  def new

  end

  def create
  	rating = user_rating_params[:rating].to_i
  	if user_rating_params[:imdb] != nil
  	 	imdb_dif = (rating - user_rating_params[:imdb].to_f)
  	else
  		imdb_dif = nil
  	end
  	
  	if user_rating_params[:meta] != nil
	  	meta_dif = (rating - user_rating_params[:meta].to_f)
  	else
  		meta_dif = nil
  	end

  	if user_rating_params[:rt] != nil
	  	rt_dif = (rating - user_rating_params[:rt].to_f)
	  else
	  	rt_dif = nil
	  end

  	@user_rating = UserRating.new(user_id: current_user.id, imdb_id: user_rating_params[:imdb_id], genres: user_rating_params[:genres],
  	 	imdb_dif: imdb_dif, meta_dif: meta_dif, rt_dif: rt_dif, rating: rating)
  	
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
    params.require(:movie).permit(:rating, :imdb, :meta, :rt, :imdb_id, :genres)
  end
end

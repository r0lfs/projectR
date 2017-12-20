class UserRatingsController < ApplicationController
  def index
  end

  def new

  end

  def create
  	puts "imdbid is #{user_rating_params[:imdb_id]}, genres are #{user_rating_params[:genres]}"
  	rating = user_rating_params[:rating].to_i
  	imdb_dif = (rating - user_rating_params[:imdb].to_f)
  	meta_dif = (rating - user_rating_params[:meta].to_f)
  	rt_dif = (rating - user_rating_params[:rt].to_f)

  	@user_rating = UserRating.new(user_id: current_user.id, imdb_id: user_rating_params[:imdb_id], genres: user_rating_params[:genres],
  	 	imdb_dif: imdb_dif, meta_dif: meta_dif, rt_dif: rt_dif, rating: rating)
  	if @user_rating.save
  		current_user.increment!(:rate_count)
  	else
  		@user_rating.errors.each do |error|
  			puts "error is #{error}"
  		end
  	end
  end

  def update
  end

  def user_rating_params
    params.require(:movie).permit(:rating, :imdb, :meta, :rt, :imdb_id, :genres)
  end
end

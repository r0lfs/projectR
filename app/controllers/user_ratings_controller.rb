class UserRatingsController < ApplicationController
  def index
  end

  def new
    @user_rating = UserRating.new
  end

  def create
    rating_params = UserRating.create_params(user_rating_params) #calls the create_params method which returns hash with UserRating values calculated

  	@user_rating = UserRating.new(rating_params)
  	
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
    params.require(:movie).permit(:user_id, :rating, :imdb, :meta, :rt, :imdb_id, :genres, :proj)
  end
end

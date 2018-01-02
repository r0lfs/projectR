class HomeController < ApplicationController
  def index
  	if !user_signed_in?
  		redirect_to new_user_session_path
  	end
  	if params[:search]
  		search
      @projected = UserRating.projected_rating(current_user, @ratings, @genres) 
  		if @ratings
  			@user_rating = current_user.user_ratings.find_by(imdb_id: @result['imdbID'])
  		end
  	end
  end

  def search
 		@result = APIS::Omdb.new.get_by_title(params[:search])

  	if @result['Response'] == 'True' #only runs if film is found
  		@ratings = APIS::Omdb.get_rate(@result) #gets the critic ratings for film
	  	@genres = @result['Genre'].split(',').map { |e| e.strip } #changes string of genres to an array 
  	end
  end

end

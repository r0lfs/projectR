class HomeController < ApplicationController
  def index
  	if !user_signed_in?
  		redirect_to new_user_session_path
  	end
  	if params[:search]
  		search
  		if @ratings
  			@user_rating = current_user.user_ratings.find_by(imdb_id: @result['imdbID'])
  		end
  	end
  end

  def search
  	if params[:search].downcase.starts_with?('tt') #checks if searching by imdb id
 			@result = APIS::Omdb.new.get_by_ID(params[:search]) 		
  	else
  		@result = APIS::Omdb.new.get_by_title(params[:search])
  	end

  	if @result['Response'] == 'True'
  		@ratings = APIS::Omdb.get_rate(@result)
	  	@genres = @result['Genre'].split(',').map { |e| e.strip }
  	end
  	
  end
end

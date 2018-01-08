class HomeController < ApplicationController
  def index
  	if !user_signed_in?
  		redirect_to new_user_session_path
  	elsif params[:search]
  		search
  	else
      rate_arrays = UserRating.set_rate(current_user)
      if rate_arrays[:not_rated].length == 0
        @nothing_left = "You've rated all our base films! We're working on adding more to the database, but for now, please utilize the search function!"
      else
        base_film(rate_arrays[:already_rated], rate_arrays[:not_rated])
      end
    end
  end

  def next_film
    already_rated = params[:already_rated]
    not_rated = params[:not_rated]
    if not_rated.length == 0
      @nothing_left = "You've rated all our base films! We're working on adding more to the database, but for now, please utilize the search function!"
    else
      base_film(already_rated, not_rated)
      respond_to do |format|
        format.js
      end
    end
  end

  

  private
  def search
 		@result = APIS::Omdb.new.get_by_title(params[:search])

  	if @result['Response'] == 'True' #only runs if film is found
  		details = UserRating.get_film_details(@result, current_user)
      @ratings = details[:ratings]
      @genres = details[:genres]
      @projected = details[:projected]
      @user_rating = details[:user_rating]
  	end
  end

  def base_film(already_rated, not_rated)
    random_rate_object = UserRating.random_film_selection(already_rated, not_rated, current_user)
    @already_rated = random_rate_object[:already_rated]
    @not_rated = random_rate_object[:not_rated]
    @result = random_rate_object[:result]
    details = UserRating.get_film_details(@result, current_user)
    @ratings = details[:ratings]
    @genres = details[:genres]
    @projected = details[:projected]
    @user_rating = details[:user_rating]
  end

  
end



class HomeController < ApplicationController
  def index
  	if !user_signed_in?
  		redirect_to new_user_session_path
  	end
  	if params[:search]
  		search
  	end
  end

  def search
  	title = params[:search]
  	@result = APIS::Omdb.new.get_by_title(title)
  	@ratings = APIS::Omdb.get_rate(@result)
  	@genres = @result['Genre'].split(',').map { |e| e.strip }
  end
end

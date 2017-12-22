require 'net/http'
require 'json'

class APIS::Omdb

	def get_by_title(title)
		JSON.parse(Net::HTTP.get(URI("http://www.omdbapi.com/?apikey=ccf82bf3&t=#{title}&plot=short")))
	end

	def get_by_ID(id)
		JSON.parse(Net::HTTP.get(URI("http://www.omdbapi.com/?apikey=ccf82bf3&i=#{id}")))
	end

	#returns hash of a film's metacritic, rotten tomatoes, and imdb scores.
	def self.get_rate(film)
		base = {}
		
		if !film['Ratings'].find {|x| x["Source"]=="Rotten Tomatoes"}.nil?
			base.merge!({rt: (film['Ratings'].find {|x| x["Source"]=="Rotten Tomatoes"}["Value"].delete!'%').to_f/10})
		else
			base.merge!({rt: nil})
		end
		
		if film['Metascore'] != 'N/A'
			base.merge!({meta: film['Metascore'].to_f/10})
		else
			base.merge!({meta: nil})
		end

		if film['imdbRating'] != 'N/A'
			base.merge!({imdb: film['imdbRating'].to_f})
		else
			base.merge!({imdb: nil})
		end

		return base
	end
end


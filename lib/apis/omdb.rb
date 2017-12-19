require 'net/http'
require 'json'

class APIS::Omdb

	def get_by_title(title)
		JSON.parse(Net::HTTP.get(URI("http://www.omdbapi.com/?apikey=ccf82bf3&t=#{title}&plot=full")))
	end

	def get_by_ID(id)
		JSON.parse(Net::HTTP.get(URI("http://www.omdbapi.com/?apikey=ccf82bf3&i=#{id}")))
	end


	def self.get_rate(film)
		base = film['Ratings'].map do |rating|
			if rating["Source"] == 'Internet Movie Database' && rating["Source"] != 'N/A'
				{imdb: (rating["Value"].delete!"/10").to_f}
			elsif rating["Source"] == 'Rotten Tomatoes' && rating["Source"] != 'N/A'
				{rt: ((rating['Value'].delete!'%').to_f / 10)}
			elsif rating["Source"] == 'Metacritic' && rating['Value'] != 'N/A'
				{meta: ((rating["Value"].delete!'/100').to_f / 10)}
			end
		end
		return base.reduce(&:merge)
	end
end


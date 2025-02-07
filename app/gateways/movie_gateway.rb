# app/gateways/movie_gateway.rb

class MovieGateway 
  def self.get_top_rated
    response = connection.get('/3/movie/top_rated')

    json = JSON.parse(response.body, symbolize_names: true)
  end

  private

  def self.connection
    Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = "Bearer #{Rails.application.credentials.tmdb[:key]}"
      faraday.headers["Content-Type"] = "application/json"
    end
  end
end
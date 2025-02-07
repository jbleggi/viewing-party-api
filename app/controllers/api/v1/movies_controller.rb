class Api::V1::MoviesController < ApplicationController
  def index
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = "Bearer #{Rails.application.credentials.tmdb[:access_token]}"
    end

    response = conn.get("/3/movie/top_rated?language=en-US&page=1")

    json = JSON.parse(response.body, symbolize_names: true)

    formatted_json = {
      data: json[:results].first(20).map do |movie|
        {
          id: movie[:id].to_s,  
          type: 'movie',
          attributes: {
            title: movie[:title],
            vote_average: movie[:vote_average]
          }
        }
      end
    }

    render json: formatted_json
  end
end

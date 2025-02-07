# app/controllers/api/v1/movies_controller.rb

class Api::V1::MoviesController < ApplicationController
  def index
    movies = Movie.all
    #   conn = Faraday.new(url:  "https://api.themoviedb.org/3") do |faraday|
    #   faraday.headers["Authorization"] = Rails.application.credentials.tmdb[:access_token]
    # end
    
    # response = conn.get("/api/v1/movies")

    # json = JSON.parse(response.body, symbolize_names: true)
  end
end

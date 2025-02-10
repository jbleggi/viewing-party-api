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

  def search
    query = params[:query]
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = "Bearer #{Rails.application.credentials.tmdb[:access_token]}"
    end

    response = conn.get("/3/search/movie?query=#{query}&language=en-US&page=1")

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

  def show
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = "Bearer #{Rails.application.credentials.tmdb[:access_token]}"
    end

    response = conn.get("/3/movie/#{params[:id]}")
    json = JSON.parse(response.body, symbolize_names: true)
   
    genres_array = json[:genres].map { |genre| genre[:name] }

    response2 = conn.get("/3/movie/#{params[:id]}/credits")
    json2 = JSON.parse(response2.body, symbolize_names: true)
    
    cast_hash = json2[:cast].first(10).map do |castmember|
      { character: castmember[:character], actor: castmember[:name] }
    end

    response3 = conn.get("/3/movie/#{params[:id]}/reviews")
    json3 = JSON.parse(response3.body, symbolize_names: true)
    reviews = json3[:results]
    reviews_array = reviews.first(5).map do |review| 
      { author: review[:author], review: review[:content]}
    end

    formatted_json = {
      id: json[:id].to_s,  
      type: 'movie',
      attributes: {
        title: json[:title],
        release_year: json[:release_date],
        vote_average: json[:vote_average],
        runtime: json[:runtime],
        genres: genres_array,
        summary: json[:overview], 
        cast: cast_hash, 
        total_reviews: json3[:total_results],
        reviews: reviews_array
      }
    }

    render json: formatted_json
  end
end

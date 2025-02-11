# bundle exec rspec spec/requests/api/v1/movies_request_spec.rb

require 'rails_helper'

RSpec.describe "Movie endpoints", type: :request do
  describe "GET #index" do
    it "retrieves 20 top rated movies", :vcr do
      get "/api/v1/movies"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to be_a Hash
      expect(json[:data].count).to eq 20

      json[:data].each do |movie|
        expect(movie[:attributes]).to have_key :title
        expect(movie[:attributes]).to have_key :vote_average
      end
    end
  end

  describe "GET #search" do
    it "retrieves results based on search params", :vcr do 
      search_term = "lord of the rings"

      get "/api/v1/movies/search?query=#{search_term})"
  
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(json).to be_a Hash
      expect(json[:data].count).to be <= 20

      json[:data].each do |movie|
        expect(movie[:attributes]).to have_key :title
        expect(movie[:attributes]).to have_key :vote_average
      end
    end

    it "handles errors gracefully" do 
    end
  end

  describe "GET #show" do 
    it "returns details about a movie", :vcr do 
      movie_id = 278

      get "/api/v1/movies/#{movie_id}"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:id]).to eq(movie_id.to_s)
      expect(json[:type]).to eq('movie')

      expect(json[:attributes][:title]).to eq("The Shawshank Redemption")
      expect(json[:attributes][:release_year]).to eq("1994")
      expect(json[:attributes][:vote_average]).to eq(8.708)
      expect(json[:attributes][:runtime]).to eq(142)
      expect(json[:attributes][:genres]).to eq(["Drama", "Crime"])
      expect(json[:attributes][:summary]).to include("Imprisoned in the 1940s")

      cast = json[:attributes][:cast]
      expect(cast.length).to eq(10)
      expect(cast.first[:character]).to eq("Andy Dufresne")
      expect(cast.first[:actor]).to eq("Tim Robbins")

      expect(json[:attributes][:total_reviews]).to eq(17)

      reviews = json[:attributes][:reviews]
      expect(reviews.length).to eq(5)
      expect(reviews.first[:author]).to eq("elshaarawy")
      expect(reviews.first[:review]).to eq("very good movie 9.5/10 محمد الشعراوى")
    end

    it "handles errors gracefully" do 
    end
  end
end
# bundle exec rspec spec/requests/api/v1/movies_request_spec.rb

require 'rails_helper'

RSpec.describe "Movie endpoints" do
  describe "GET #index" do
    it "retrieves 20 top rated movies" do
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
    it "retrieves results based on search params" do 
      search_term = "lord of the rings"

      get("/api/v1/movies/search?query=#{search_term})")
  
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(json).to be_a Hash
      expect(json[:data].count).to be <= 20

      json[:data].each do |movie|
        expect(movie[:attributes]).to have_key :title
        expect(movie[:attributes]).to have_key :vote_average
      end
    end
  end
end
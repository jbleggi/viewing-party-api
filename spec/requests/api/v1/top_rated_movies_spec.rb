# bundle exec rspec spec/requests/api/v1/top_rated_movies_spec.rb
require 'rails_helper'

RSpec.describe "Top Rated Movies Endpoint", type: :request do
    describe "happy path" do 
        before do
            json_response = File.read('spec/fixtures/top_rated_movies_query.json')
            stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=e1e0c6d7f384fcefdcacefea6f6f8e5e").to_return(status: 200, body: json_response)

            get "/api/v1/movie"
        
        end
        it "can retrieve top-rated movies from API" do
            
        end

        it "can retrieve a maximum of 20 results" do
        end

        it "includes the title and vote average of every movie" do
        end    
    end
end

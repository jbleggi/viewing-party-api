# bundle exec rspec spec/requests/api/v1/top_rated_movies_spec.rb
require 'rails_helper'

RSpec.describe "Top Rated Movies Endpoint", type: :request do
    describe "happy path" do 
        it "can retrieve top-rated movies from API" do
        end

        it "can retrieve a maximum of 20 results" do
        end

        it "includes the title and vote average of every movie" do
        end    
    end
end

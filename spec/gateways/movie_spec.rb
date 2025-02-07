# bundle exec rspec spec/gateways/movie_spec.rb

require "rails_helper"

RSpec.describe MovieGateway do
    it 'should return a maximum of 20 Movie objects when queried' do 
        WebMock.allow_net_connect!
        
        results = MovieGateway.get_top_rated
        expect(results.count).to eq 20
        expect(results[0]).to be_a Movie
    end
end
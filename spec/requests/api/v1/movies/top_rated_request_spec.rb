require "rails_helper"

RSpec.describe "Movies top rated request endpoint" do
  describe "happy path" do
    it "retrieves 20 rated movies" do
      get api_v1_movies_path

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to be_an Array
    end
  end
end
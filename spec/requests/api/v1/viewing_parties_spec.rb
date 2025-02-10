# bundle exec rspec spec/requests/api/v1/viewing_parties_spec.rb
# rm spec/fixtures/vcr_cassettes/* # Deletes all cassettes


require 'rails_helper'

RSpec.describe "ViewingParty endpoints", type: :request do
  before do 
    @user_1 = create(:user)
    @user_2 = create(:user)
    @user_3 = create(:user)
    @user_4 = create(:user)

    @movie = create(:movie)

    @vp_params =     {
      name: "Juliet's Bday Movie Bash!",
      start_time: "2025-02-01 10:00:00",
      end_time: "2025-02-01 14:30:00",
      movie_id: @movie.id,
      movie_title: @movie.title,
      invitees: [@user_1.id, @user_2.id, @user_3.id], 
      host_id: @user_4.id
    }

    @vp_bad_params = {
      name: "Juliet's bday bash",
      movie_id: @movie.id
    }

  end

  describe "POST #create" do
    describe "happy path" do
      it 'creates a viewing party and returns success response with invited users', :vcr do
        post '/api/v1/viewing_parties', params: @vp_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:message]).to eq("Viewing Party created successfully")
        expect(json[:party][:invited_users]).to include(*[@user_1.username, @user_2.username, @user_3.username, @user_4.username])
      end
    end


    describe "sad paths" do
    end
  end
end
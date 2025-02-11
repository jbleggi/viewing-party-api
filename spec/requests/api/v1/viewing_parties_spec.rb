# bundle exec rspec spec/requests/api/v1/viewing_parties_spec.rb
# rm spec/fixtures/vcr_cassettes/* # Deletes all cassettes


require 'rails_helper'

RSpec.describe "ViewingParty endpoints", type: :request do
  before do 
    @user_1 = create(:user)
    @user_2 = create(:user)
    @user_3 = create(:user)
    @user_4 = create(:user)
    @user_5 = create(:user)

    @movie = create(:movie)

    @vp_params = {
      viewing_party: {
        name: "Juliet's Bday Movie Bash!",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: @movie.id,
        movie_title: @movie.title,
        invitees: [@user_1.id, @user_2.id, @user_3.id],
        host_id: @user_4.id
      }
    }

    @vp_bad_params = {
      name: "Juliet's bday bash",
      movie_id: @movie.id
    }

  end

  describe "POST #create" do
    describe "happy path" do
      it 'creates a viewing party and returns success response with invited users', :vcr do
        post '/api/v1/viewing_parties', params: @vp_params

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body, symbolize_names: true)
        attributes = json[:data][:attributes]
        invitees = json[:data][:invitees]

        expect(json[:message]).to eq("Viewing Party created successfully")
        expect(json[:data][:type]).to eq("viewing_party")

        expect(attributes).to have_key :name
        expect(attributes).to have_key :start_time
        expect(attributes).to have_key :end_time
        expect(attributes).to have_key :movie_id
        expect(attributes).to have_key :movie_title

        expect(invitees.count).to eq 3
          expect(invitees).to include(
          { id: @user_1.id, name: @user_1.name, username: @user_1.username },
          { id: @user_2.id, name: @user_2.name, username: @user_2.username },
          { id: @user_3.id, name: @user_3.name, username: @user_3.username }
        )
      end
     end


    describe "sad paths" do
    end
  end

  describe "POST #add_users" do 
    it "adds new user to existing viewing party" do 
      @viewing_party = create(:viewing_party, host_id: @user_4.id)
      @viewing_party.users << @user_1
      @viewing_party.users << @user_2

      expect(@viewing_party.users).not_to include(@user_5)

      post "/api/v1/viewing_parties/#{@viewing_party.id}/users", params: { invitees: [@user_5.id] }
     
      @viewing_party.reload

      expect(@viewing_party.users.pluck(:username)).to include(@user_5.username)

      expect(response).to be_successful
    end
  end
      
end
class Api::V1::ViewingPartiesController < ApplicationController
  def index
    @viewing_parties = ViewingParty.all
    render json: @viewing_parties
  end
  
  # POST /api/v1/viewing_parties/:id/users
  
  def add_users
    @viewing_party = ViewingParty.find(params[:id])

    @invitee_ids = params[:invitees]

    @invitee_ids.each do |invitee_id|
      invitee = User.find_by(id: invitee_id)
      if invitee
        @viewing_party.users << invitee
      else
        return render json: { error: "User with ID #{invitee_id} not found" }, status: :not_found
      end
    end

    # Return the updated list of users in the party
    render json: {
      message: 'Users added successfully',
      invited_users: @viewing_party.users.pluck(:username)
    }, status: :ok
  end

  # POST /api/v1/viewing_parties
  def create
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = "Bearer #{Rails.application.credentials.tmdb[:access_token]}"
    end
    
    @viewing_party = ViewingParty.new(viewing_party_params)

    response = conn.get("/3/movie/#{@viewing_party.movie_id}")
    json = JSON.parse(response.body, symbolize_names: true)
    movie_runtime = json[:runtime]
    if movie_runtime.nil?
      return render json: { error: 'Movie runtime could not be fetched' }, status: :unprocessable_entity
    end
    

    party_duration = (@viewing_party.end_time - @viewing_party.start_time) / 60 

    if @viewing_party.end_time <= @viewing_party.start_time
      return render json: { error: 'End time must be after the start time' }, status: :unprocessable_entity
    end

    if party_duration < movie_runtime
      return render json: { error: 'Party duration must be at least as long as the movie runtime' }, status: :unprocessable_entity
    end

    if @viewing_party.save    
      render json: {
        message: 'Viewing Party created successfully',
        data: {
          id: @viewing_party.id,
          type: "viewing_party",
          attributes: {
            name: @viewing_party.name,
            start_time: @viewing_party.start_time,
            end_time: @viewing_party.end_time,
            movie_id: @viewing_party.movie_id,
            movie_title: @viewing_party.movie_title,
          },
          invitees:  @viewing_party.invitees.map do |user_id|
            user = User.find_by(id: user_id) 
            { id: user.id, name: user.name, username: user.username } 
          end
        }}, status: :created
    else
      render json: @viewing_party.errors, status: :unprocessable_entity
    end
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :host_id, :start_time, :end_time, :movie_id, :movie_title, invitees: [])
  end
 end

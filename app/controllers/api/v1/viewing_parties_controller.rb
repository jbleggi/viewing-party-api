class Api::V1::ViewingPartiesController < ApplicationController
  def index
    @viewing_parties = ViewingParty.all
    render json: @viewing_parties
  end
  
  # POST /api/v1/viewing_parties/:id/users
  
  def add_users
    @viewing_party = ViewingParty.find_by(id: params[:id])

    # Check if the viewing party exists
    unless @viewing_party
      return render json: { error: "Viewing Party not found" }, status: :not_found
    end

    # Retrieve invitees from the request parameters
    invitees = params[:invitees]

    # Validate that invitees are present
    if invitees.nil? || invitees.empty?
      return render json: { error: 'No invitees provided' }, status: :unprocessable_entity
    end

    # Add invitees to the party
    invitees.each do |invitee_id|
      invitee = User.find_by(id: invitee_id)
      if invitee
        @viewing_party.users << invitee unless @viewing_party.users.include?(invitee)
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
    @viewing_party = ViewingParty.new(viewing_party_params)

    # Get the movie's runtime from TMDb API
    movie_runtime = get_movie_runtime(@viewing_party.movie_id)
    if movie_runtime.nil?
      return render json: { error: 'Movie not found or missing runtime' }, status: :unprocessable_entity
    end

    # Ensure the viewing party duration is at least as long as the movie runtime
    if @viewing_party.end_time <= @viewing_party.start_time
      return render json: { error: 'End time must be after the start time' }, status: :unprocessable_entity
    end

    party_duration = (@viewing_party.end_time - @viewing_party.start_time) / 60 # In minutes
    if party_duration < movie_runtime
      return render json: { error: 'Party duration must be at least as long as the movie runtime' }, status: :unprocessable_entity
    end

    if @viewing_party.save
      # Add the host as an invitee
      host = User.find(@viewing_party.host_id)
      @viewing_party.users << host


      # Add the invitees to the party
      invitees = params[:viewing_party][:invitees]
      if invitees.present?
        invitees.each do |invitee_id|
          invitee = User.find_by(id: invitee_id)
          if invitee
            @viewing_party.users << invitee unless @viewing_party.users.include?(invitee)
          else
            render json: { error: "User with ID #{invitee_id} not found" }, status: :not_found
            return
          end
        end
      end

      # Return success response with the viewing party details
      render json: {
        message: 'Viewing Party created successfully',
        party: {
          party_name: @viewing_party.name,
          host: host.username,
          invited_users: @viewing_party.users.pluck(:username)
        }
      }, status: :created
    else
      # If party save fails, return validation errors
      render json: @viewing_party.errors, status: :unprocessable_entity
    end

  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :host_id, :start_time, :end_time, :movie_id, invitees: [])
  end

  # Helper method to fetch movie runtime from TMDb API
  def get_movie_runtime(movie_id)
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = "Bearer #{Rails.application.credentials.tmdb[:access_token]}"
    end
    
    response = conn.get("3/movie/#{movie_id}")
    json = JSON.parse(response.body, symbolize_names: true)
    
    json[:runtime]
  end
end

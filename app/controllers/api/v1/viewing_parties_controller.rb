class Api::V1::ViewingPartiesController < ApplicationController
  # POST /api/v1/viewing_parties
  def create
    # Ensure we have a valid user_id (host)
    host_id = params[:viewing_party][:host_id]
    @host = User.find_by(id: host_id)
    unless @host
      return render json: { error: 'Host not found' }, status: :unprocessable_entity
    end

    # Initialize the new viewing party with strong parameters
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

    # Save the viewing party
    if @viewing_party.save
      # Add the host as an invitee
      @viewing_party.users << @host

      # Handle invitees (user IDs)
      invitee_ids = params[:viewing_party][:invitees]
      if invitee_ids.present?
        valid_users = User.where(id: invitee_ids)
        @viewing_party.users << valid_users
      end

      # Return the viewing party with relationships
      render json: @viewing_party, status: :created, location: api_v1_viewing_party_path(@viewing_party)
      else
      # Handle the case where the viewing party fails validation (other attributes)
      render json: { errors: @viewing_party.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title, :host_id)
  end

  # Helper method to fetch movie runtime from TMDb API
  def get_movie_runtime(movie_id)
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = "Bearer #{Rails.application.credentials.tmdb[:access_token]}"
    end
    
    response = conn.get("3/movie/#{movie_id}")
    json = JSON.parse(response.body, symbolize_names: true)
    
    json[:runtime]

  rescue StandardError => e
    # Handle any errors that might occur (e.g., network issues)
    nil
  end
end

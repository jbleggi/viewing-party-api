class MovieSerializer
  include JSONAPI::Serializer
  set_type :movie
  set_id :id
  attributes :title, :vote_average
end
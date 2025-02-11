class UserViewingParty < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id'
  belongs_to :viewing_party
end

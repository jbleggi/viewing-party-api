require 'rails_helper'

RSpec.describe UserViewingParty, type: :model do
  it 'should belong to User' do 
    should belong_to(:user).with_foreign_key('invitee_id')    
  end

  it 'should belong to Viewing Party' do
    should belong_to(:viewing_party)
  end
end

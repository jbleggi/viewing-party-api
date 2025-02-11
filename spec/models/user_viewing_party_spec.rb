require 'rails_helper'

RSpec.describe UserViewingParty, type: :model do
  describe "relationships" do 
    it { should belong_to(:user).with_foreign_key('user_id') }   
    it { should belong_to(:viewing_party) }
  end
end

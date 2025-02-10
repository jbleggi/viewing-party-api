require 'rails_helper'

RSpec.describe ViewingParty, type: :model do
  describe "relationships" do
    it { should belong_to(:host).class_name('User').with_foreign_key('host_id') }
    it { should have_many(:user_viewing_parties) }
    it { should have_many(:users).through(:user_viewing_parties) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_presence_of(:movie_id) }
    it { should validate_presence_of(:movie_title) }
  end

end

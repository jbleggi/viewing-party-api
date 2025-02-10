class CreateUserViewingParties < ActiveRecord::Migration[7.1]
  def change
    create_table :user_viewing_parties do |t|
      t.integer :host_id
      t.integer :invitee_id
      t.integer :viewing_party_id

      t.timestamps
    end
  end
end

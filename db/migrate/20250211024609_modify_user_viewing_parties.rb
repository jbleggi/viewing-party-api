class ModifyUserViewingParties < ActiveRecord::Migration[7.1]
  def change
    rename_column :user_viewing_parties, :invitee_id, :user_id
  end
end

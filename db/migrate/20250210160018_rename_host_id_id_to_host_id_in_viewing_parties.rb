class RenameHostIdIdToHostIdInViewingParties < ActiveRecord::Migration[7.1]
  def change
    rename_column :viewing_parties, :host_id_id, :host_id
  end
end

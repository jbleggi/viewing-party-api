class UpdateViewingParties < ActiveRecord::Migration[7.1]
  def change
    remove_column :viewing_parties, :host_id, :integer
    add_reference :viewing_parties, :host_id, foreign_key: { to_table: :users }, null: false
  end
end

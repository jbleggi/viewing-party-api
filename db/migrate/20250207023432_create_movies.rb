class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.float :vote_average

      t.timestamps
    end
  end
end

class CreateUserRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_ratings do |t|
    	t.references :user
    	t.string :imdb_id
    	t.string :genres
    	t.float :imdb_dif, default: 0.0
    	t.float :meta_dif, default: 0.0
    	t.float :rt_dif, default: 0.0
    	t.integer :rating

      t.timestamps
    end
  end
end

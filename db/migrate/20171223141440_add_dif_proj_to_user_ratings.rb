class AddDifProjToUserRatings < ActiveRecord::Migration[5.1]
  def self.up
  	add_column :user_ratings, :dif_projected, :float, default: 0.0
  end
end

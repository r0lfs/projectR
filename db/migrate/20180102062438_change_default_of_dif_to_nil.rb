class ChangeDefaultOfDifToNil < ActiveRecord::Migration[5.1]
  def change
  	change_column :user_ratings, :dif_projected, :float, default: nil
  end
end

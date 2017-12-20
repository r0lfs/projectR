class AddRatedCountToUsers < ActiveRecord::Migration[5.1]
  def self.up
  	add_column :users, :rate_count, :integer, default: 0
  end
end

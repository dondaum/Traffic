class AddLatitudeAndLongitudeToDistance < ActiveRecord::Migration[5.0]
  def change
    add_column :distances, :latitude, :float
    add_column :distances, :longitude, :float
  end
end

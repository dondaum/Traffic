class AddDestinationLatAndDestinationLongToDistance < ActiveRecord::Migration[5.0]
  def change
    add_column :distances, :Destination_Lat, :float
    add_column :distances, :Destination_Long, :float
  end
end

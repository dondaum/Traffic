class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :distances, :Destination_Lat, :destination_lat
    rename_column :distances, :Destination_Long, :destination_long
  end
end

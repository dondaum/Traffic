class AddRangeToDistance < ActiveRecord::Migration[5.0]
  def change
    add_column :distances, :range, :float
  end
end

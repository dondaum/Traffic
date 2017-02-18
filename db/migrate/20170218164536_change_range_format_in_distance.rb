class ChangeRangeFormatInDistance < ActiveRecord::Migration[5.0]
  def change
    change_column :distances, :range, :decimal, :precision =>10 
    change_column :distances, :gmaprange, :decimal, :precision =>10
  end
end

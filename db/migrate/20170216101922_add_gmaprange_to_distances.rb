class AddGmaprangeToDistances < ActiveRecord::Migration[5.0]
  def change
    add_column :distances, :gmaprange, :decimal, :precision =>2
  end
end

class ChangeDataTypeForDistance < ActiveRecord::Migration[5.0]
  def change
     change_column :distances, :range, :decimal, :precision =>2
  end
end

class CreateDistances < ActiveRecord::Migration[5.0]
  def change
    create_table :distances do |t|
      t.string :startpunkt
      t.string :zielpunkt
      t.string :verkehrsmittel
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :distances, [:user_id, :created_at]
  end
end

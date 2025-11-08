class CreateRooms < ActiveRecord::Migration[7.2]
  def change
    create_table :rooms do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.string :image
      t.timestamps
    end
  end
end

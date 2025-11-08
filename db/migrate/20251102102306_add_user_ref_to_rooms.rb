class AddUserRefToRooms < ActiveRecord::Migration[7.2]
  def change
    add_reference :rooms, :user, null: false, foreign_key: true
  end
end

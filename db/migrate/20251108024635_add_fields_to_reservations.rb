class AddFieldsToReservations < ActiveRecord::Migration[6.1]
  def change
    add_reference :reservations, :room, foreign_key: true, index: true unless column_exists?(:reservations, :room_id)
    add_column :reservations, :check_in, :date unless column_exists?(:reservations, :check_in)
    add_column :reservations, :check_out, :date unless column_exists?(:reservations, :check_out)
    add_column :reservations, :guests, :integer, default: 1, null: false unless column_exists?(:reservations, :guests)
    add_column :reservations, :total_price, :integer unless column_exists?(:reservations, :total_price)
  end
end

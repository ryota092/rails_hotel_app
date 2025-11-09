class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :icon, default: "default_icon.png"
      t.string :password_digest, null: false
      t.timestamps
    end
  end
end

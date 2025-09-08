class CreateRestaurants < ActiveRecord::Migration[8.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :slug
      t.string :currency
      t.decimal :vat_rate, precision: 4, scale: 2
      t.string :address

      t.timestamps
    end
    add_index :restaurants, :slug, unique: true
  end
end

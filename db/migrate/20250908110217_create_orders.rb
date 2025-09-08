class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.references :table, null: false, foreign_key: true
      t.string :status
      t.integer :subtotal_cents
      t.integer :vat_cents
      t.integer :total_cents
      t.integer :paid_cents

      t.timestamps
    end
  end
end

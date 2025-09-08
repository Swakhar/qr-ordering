class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :menu_item, null: false, foreign_key: true
      t.string :name_snapshot
      t.integer :price_cents
      t.integer :qty
      t.string :notes

      t.timestamps
    end
  end
end

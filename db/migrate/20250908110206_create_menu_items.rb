class CreateMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items do |t|
      t.references :menu_category, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.integer :price_cents
      t.jsonb :allergens
      t.string :image_url
      t.boolean :is_active
      t.jsonb :upsell_targets

      t.timestamps
    end
  end
end

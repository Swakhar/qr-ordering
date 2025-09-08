class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.string :stripe_payment_intent
      t.integer :amount_cents
      t.string :status

      t.timestamps
    end
    add_index :payments, :stripe_payment_intent, unique: true
  end
end

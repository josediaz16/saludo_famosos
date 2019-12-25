class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.string :cc_holder, null: false, default: ""
      t.decimal :value, null: false, default: 0.0, precision: 10, scale: 2
      t.string :email_buyer, null: false, default: ""
      t.string :response_code, null: false, default: ""
      t.string :payment_method_name, null: false, default: ""
      t.string :transaction_id, null: false, default: ""
      t.string :currency, null: false, default: ""
      t.datetime :transaction_date, null: false
      t.references :message_request, null: false, foreign_key: true
      t.jsonb  :response, null: false, default: {}
      t.timestamps
    end
  end
end

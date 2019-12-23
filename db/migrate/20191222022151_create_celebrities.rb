class CreateCelebrities < ActiveRecord::Migration[6.0]
  def change
    create_table :celebrities do |t|
      t.text :biography, null: false, default: ""
      t.decimal :price, null: false, precision: 10, scale: 2, default: 0.0
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

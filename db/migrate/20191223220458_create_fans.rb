class CreateFans < ActiveRecord::Migration[6.0]
  def change
    create_table :fans do |t|
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

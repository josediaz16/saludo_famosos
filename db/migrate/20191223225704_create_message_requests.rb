class CreateMessageRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :message_requests do |t|
      t.text :brief, null: false, default: ""
      t.string :to, null: false, default: ""
      t.string :from, null: false, default: ""
      t.string :phone_to, null: false, default: ""
      t.string :recipient_type, null: false, default: ""
      t.string :reference_code, null: false, default: ""
      t.string :status, null: false, default: 'pending'
      t.references :celebrity, index: true, foreign_key: true
      t.references :fan, null: true, foreign_key: true
    end
  end
end

class AddsHandleAndPhotoPositionToCelebrities < ActiveRecord::Migration[6.0]
  def change
    add_column :celebrities, :handle, :string, null: false, default: ""
    add_column :celebrities, :photo_position, :string, null: false, default: ""
  end
end

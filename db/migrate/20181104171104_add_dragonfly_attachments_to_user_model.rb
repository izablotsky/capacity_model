class AddDragonflyAttachmentsToUserModel < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :photo_uid,  :string
    add_column :users, :photo_name, :string
  end
end

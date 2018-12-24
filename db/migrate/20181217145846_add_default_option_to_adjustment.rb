class AddDefaultOptionToAdjustment < ActiveRecord::Migration[5.2]
  def change
    add_column :adjustments, :default, :boolean, default: false, allow_nil: false
  end
end

class ChangeAssignedResourceTable < ActiveRecord::Migration[5.2]
  def change
    rename_column :assigned_resources, :involvement, :distribution_involvement
    add_column :assigned_resources, :allocation_involvement, :integer, default: 0
  end
end

class ChangeProjectToAdjustmentAssociations < ActiveRecord::Migration[5.2]
  def change
    change_table :assigned_resources do |t|
      t.remove_references :project
      t.belongs_to :adjustment
    end

    change_table :estimations do |t|
      t.remove_references :project
      t.belongs_to :adjustment
    end
  end
end

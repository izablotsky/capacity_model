class AddEndDateToAdjustment < ActiveRecord::Migration[5.2]
  def change
    rename_column :adjustments, :date, :start_date
    add_column :adjustments, :end_date, :datetime
  end
end

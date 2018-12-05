class DropCalendarDaysTable < ActiveRecord::Migration[5.2]
  def up
    drop_table :calendar_days
  end

  def down
    create_table :calendar_days do |t|
      t.date :date, null: false
    end
  end
end

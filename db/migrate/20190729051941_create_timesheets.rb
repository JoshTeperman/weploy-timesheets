class CreateTimesheets < ActiveRecord::Migration[5.2]
  def change
    create_table :timesheets do |t|
      t.date :date
      t.time :start_time
      t.time :end_time
      t.float :amount
      
      t.timestamps
    end
  end
end

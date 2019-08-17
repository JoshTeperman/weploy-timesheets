class AddApprovalDateToTimesheets < ActiveRecord::Migration[5.2]
  def change
    add_column :timesheets, :approval_date, :date
  end
end

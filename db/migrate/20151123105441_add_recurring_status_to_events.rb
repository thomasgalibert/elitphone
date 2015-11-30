class AddRecurringStatusToEvents < ActiveRecord::Migration
  def change
    add_column :events, :recurring_status, :string
  end
end

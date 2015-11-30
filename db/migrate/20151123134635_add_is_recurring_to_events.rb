class AddIsRecurringToEvents < ActiveRecord::Migration
  def change
    add_column :events, :is_recurring, :boolean
  end
end

class ChangeColumnEndHourAgendas < ActiveRecord::Migration
  def change
    remove_column :agendas, :end_hour_decimal
    add_column :agendas, :end_hour, :decimal
  end
end

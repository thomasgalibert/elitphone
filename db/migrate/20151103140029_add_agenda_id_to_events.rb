class AddAgendaIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :agenda_id, :integer
  end
end

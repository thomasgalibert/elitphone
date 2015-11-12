class AddNameCabinetToAgendas < ActiveRecord::Migration
  def change
    add_column :agendas, :name_cabinet, :string
  end
end

class AddTelToCabinetDetails < ActiveRecord::Migration
  def change
    add_column :cabinet_details, :tel, :string
  end
end

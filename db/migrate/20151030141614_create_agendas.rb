class CreateAgendas < ActiveRecord::Migration
  def change
    create_table :agendas do |t|
      t.integer :company_id
      t.integer :user_id
      t.string :name
      t.integer :step
      t.decimal :start_hour
      t.string :end_hour_decimal
      t.boolean :archived

      t.timestamps
    end
  end
end

class CreateCabinetDetails < ActiveRecord::Migration
  def change
    create_table :cabinet_details do |t|
      t.string :name
      t.text :street
      t.string :zipcode
      t.string :town
      t.string :specialty
      t.integer :user_id

      t.timestamps
    end
  end
end

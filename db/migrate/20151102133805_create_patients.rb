class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.integer :company_id
      t.string :gender
      t.string :name
      t.string :firstname
      t.string :email
      t.string :tel
      t.text :street
      t.string :zipcode
      t.string :town

      t.timestamps
    end
  end
end

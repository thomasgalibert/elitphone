class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :number
      t.string :email
      t.string :tel
      t.boolean :cgv

      t.timestamps
    end
  end
end

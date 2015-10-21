class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :company_id
      t.string :name
      t.string :firstname
      t.string :email
      t.string :role
      t.string :password_digest

      t.timestamps
    end
  end
end

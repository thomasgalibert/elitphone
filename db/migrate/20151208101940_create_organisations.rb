class CreateOrganisations < ActiveRecord::Migration
  def change
    create_table :organisations do |t|
      t.integer :company_id
      t.integer :user_id
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end

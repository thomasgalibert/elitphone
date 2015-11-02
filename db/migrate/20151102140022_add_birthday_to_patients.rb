class AddBirthdayToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :birthday, :date
  end
end

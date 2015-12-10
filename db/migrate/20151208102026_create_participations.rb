class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.integer :organisation_id
      t.integer :user_id

      t.timestamps
    end
  end
end

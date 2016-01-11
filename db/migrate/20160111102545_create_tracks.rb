class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.integer :event_id
      t.integer :user_id
      t.datetime :start_at
      t.datetime :end_at
      t.string :status
      t.text :comments

      t.timestamps
    end
  end
end

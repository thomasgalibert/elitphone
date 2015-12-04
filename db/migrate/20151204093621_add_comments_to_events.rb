class AddCommentsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :comments, :text
  end
end

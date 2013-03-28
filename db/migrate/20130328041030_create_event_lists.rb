class CreateEventLists < ActiveRecord::Migration
  def change
    create_table :event_lists do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end

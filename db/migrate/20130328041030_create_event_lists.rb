class CreateEventLists < ActiveRecord::Migration
  def change
    create_table :event_lists do |t|
      t.integer :account_id, null: false
      t.string :name, null: false
      t.timestamps
    end

    add_index :event_lists, :account_id
  end
end

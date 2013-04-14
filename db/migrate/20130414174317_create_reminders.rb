class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.integer :event_id, null: false
      t.datetime :reminded_at, null: false
      t.timestamps
    end

    add_index :reminders, :event_id
  end
end

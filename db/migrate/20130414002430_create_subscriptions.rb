class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :event_list_id, null: false
      t.integer :subscriber_id, null: false
      t.timestamps
    end

    add_index :subscriptions, :event_list_id
    add_index :subscriptions, :subscriber_id
  end
end

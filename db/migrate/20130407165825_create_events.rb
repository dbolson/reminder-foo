class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :account_id, null: false
      t.integer :event_list_id, null: false
      t.string :name, null: false
      t.string :description, null: false
      t.datetime :due_at, null: false
      t.timestamps
    end

    add_index :events, :account_id
    add_index :events, :event_list_id
  end
end

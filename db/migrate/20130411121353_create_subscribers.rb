class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.integer :account_id, null: false
      t.string :phone_number
      t.timestamps
    end

    add_index :subscribers, :account_id
  end
end

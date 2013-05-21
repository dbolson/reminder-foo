class AddAccountIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :account_id, :integer, null: false
    add_index :subscriptions, :account_id
  end
end

class AddForeignKeyIndexesToRequestAndResponse < ActiveRecord::Migration
  def change
    add_index :requests, :account_id
    add_index :requests, :api_key_id
    add_index :responses, :account_id
  end
end

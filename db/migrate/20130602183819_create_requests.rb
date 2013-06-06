class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :account_id, null: false
      t.integer :api_key_id, null: false
      t.string :ip_address, null: false
      t.string :url, null: false
      t.string :http_verb, null: false
      t.text :params
      t.timestamps
    end
  end
end

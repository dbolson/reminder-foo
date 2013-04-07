class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.integer :account_id, null: false
      t.string :access_token, null: false
      t.timestamps
    end

    add_index :api_keys, :account_id
    add_index :api_keys, :access_token, unique: true
  end
end

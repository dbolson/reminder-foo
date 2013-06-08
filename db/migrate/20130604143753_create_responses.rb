class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :account_id, null: true
      t.integer :status, null: false
      t.string :content_type, null: false
      t.text :body, null: false
      t.timestamps
    end
  end
end

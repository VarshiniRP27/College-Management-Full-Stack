class CreateApiTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :api_tokens do |t|
      t.string :token, null: false
      t.string :user_type, null: false
      t.integer :user_id, null: false
      t.datetime :expires_at

      t.timestamps
    end

    add_index :api_tokens, :token, unique: true
    add_index :api_tokens, [ :user_type, :user_id ]
  end
end

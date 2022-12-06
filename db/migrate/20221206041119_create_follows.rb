class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.integer :follower_id
      t.integer :followee_id
      t.string :status, default: 'active'

      t.timestamps
    end

    add_index :follows, [:follower_id, :status], name: 'active_follows'
    add_foreign_key :follows, :users, column: :follower_id
  end
end

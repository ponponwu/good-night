class CreateAlarms < ActiveRecord::Migration[7.0]
  def change
    create_table :alarms do |t|
      t.integer :user_id
      t.datetime :slept_at
      t.datetime :awoke_at
      t.integer :period_of_sleep

      t.timestamps
    end

    add_index :alarms, :user_id
    add_index :alarms, :period_of_sleep
    add_foreign_key :alarms, :users
  end
end

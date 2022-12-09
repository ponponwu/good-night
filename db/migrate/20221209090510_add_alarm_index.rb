class AddAlarmIndex < ActiveRecord::Migration[7.0]
  def change
    add_index :alarms, [:user_id, :awoke_at], name: 'index_alarms_on_user_id_awoke_at'
  end
end

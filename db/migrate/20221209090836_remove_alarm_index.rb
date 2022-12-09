class RemoveAlarmIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :alarms, name: 'index_alarms_on_user_id'
  end
end

class ChangeFollowIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :follows, name: 'active_follows'
    add_index :follows, [:follower_id, :followee_id, :status], name: 'index_follows_on_followees_status'
  end
end

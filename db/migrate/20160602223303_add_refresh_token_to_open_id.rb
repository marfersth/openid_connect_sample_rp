class AddRefreshTokenToOpenId < ActiveRecord::Migration
  def change
    add_column :open_ids, :refresh_token, :string, limit: 1024
  end
end

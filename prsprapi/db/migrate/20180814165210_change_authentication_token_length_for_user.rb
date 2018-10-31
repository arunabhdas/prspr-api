class ChangeAuthenticationTokenLengthForUser < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :authentication_token, :string, limit: 55
  end
end

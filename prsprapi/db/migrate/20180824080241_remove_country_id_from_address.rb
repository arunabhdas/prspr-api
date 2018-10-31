class RemoveCountryIdFromAddress < ActiveRecord::Migration[5.1]
  def change
    remove_column :addresses, :country_id, :integer
  end
end

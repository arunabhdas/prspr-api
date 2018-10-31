class AddCountryIdToAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :country_id, :integer
  end
end

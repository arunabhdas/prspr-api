class AddColumnsToAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :address_line_1, :string
    add_column :addresses, :address_line_2, :string
    add_column :addresses, :unit, :string
    add_column :addresses, :postal_code, :string
    add_column :addresses, :city, :string
    add_column :addresses, :notes, :string
    add_column :addresses, :latitude, :string
    add_column :addresses, :longitude, :string

  end
end

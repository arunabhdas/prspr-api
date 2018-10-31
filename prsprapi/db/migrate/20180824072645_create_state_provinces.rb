class CreateStateProvinces < ActiveRecord::Migration[5.1]
  def change
    create_table :state_provinces do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end

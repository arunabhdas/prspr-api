class CreateProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :properties do |t|
      t.string :title
      t.string :desc
      t.string :address_id
      t.string :avatar_url
      t.timestamps
    end
  end
end

class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.references :owner
      t.references :user
      t.timestamps
    end
  end
end

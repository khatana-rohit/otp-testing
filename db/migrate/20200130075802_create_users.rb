class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.text :name
      t.string :country_code
      t.text :phone_number

      t.timestamps
    end
  end
end

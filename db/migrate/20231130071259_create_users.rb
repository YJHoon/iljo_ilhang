class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.date :birth
      t.string :phone
      t.integer :gender, default: 0
      t.string :uid
      t.json :response
      t.string :access_token

      t.timestamps
    end
  end
end

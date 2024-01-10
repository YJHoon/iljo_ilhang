class CreateMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :members do |t|
      t.references :political_party, foreign_key: true
      t.references :election, foreign_key: true
      t.string :name
      t.string :image
      t.date :birth
      t.integer :gender, default: 0
      t.integer :status, default: 0
      t.json :response

      t.timestamps
    end
  end
end

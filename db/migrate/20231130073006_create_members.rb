class CreateMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :members do |t|
      t.references :political_party, foreign_key: true
      t.references :election, foreign_key: true
      t.string :name
      t.string :region
      t.string :birth
      t.string :edu
      t.string :job
      t.string :career1
      t.string :career2
      t.string :hubo_id
      t.integer :gender, default: 0
      t.boolean :status, default: 0

      t.timestamps
    end
  end
end

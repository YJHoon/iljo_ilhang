class CreateCandidates < ActiveRecord::Migration[7.1]
  def change
    create_table :candidates do |t|
      t.references :political_party, foreign_key: true
      t.references :election, foreign_key: true
      t.string :name
      t.string :image
      t.string :region
      t.date :birth
      t.integer :gender, default: 0
      t.integer :status, default: 0
      t.string :hubo_id
      t.json :reponse

      t.timestamps
    end
  end
end

class CreatePoliticalParties < ActiveRecord::Migration[7.1]
  def change
    create_table :political_parties do |t|
      t.string :name
      t.string :banner_image
      t.string :logo_image
      t.boolean :is_active, default: false
      t.string :color

      t.timestamps
    end
  end
end

class CreatePoliticalParties < ActiveRecord::Migration[7.1]
  def change
    create_table :political_parties do |t|
      t.string :name
      t.string :banner_image
      t.boolean :is_active, default: false
      t.float :average_attendance, default: 0
      t.integer :members_count, default: 0

      t.timestamps
    end
  end
end

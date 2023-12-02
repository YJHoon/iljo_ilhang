class CreateElections < ActiveRecord::Migration[7.1]
  def change
    create_table :elections do |t|
      t.string :title
      t.string :date
      t.string :sg_id
      t.boolean :is_active, default: false

      t.timestamps
    end
  end
end

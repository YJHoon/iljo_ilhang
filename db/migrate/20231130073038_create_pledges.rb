class CreatePledges < ActiveRecord::Migration[7.1]
  def change
    create_table :pledges do |t|
      t.references :member, foreign_key: true
      t.string :title
      t.string :goal
      t.string :method
      t.string :period
      t.string :plan

      t.timestamps
    end
  end
end

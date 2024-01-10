class CreateBillMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :bill_members do |t|
      t.references :member, foreign_key: true
      t.references :bill, foreign_key: true
      t.string :name
      t.integer :proposer_type, default: 0

      t.timestamps
    end
  end
end

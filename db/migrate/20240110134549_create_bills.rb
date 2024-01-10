class CreateBills < ActiveRecord::Migration[7.1]
  def change
    create_table :bills do |t|
      t.string :bill_id
      t.string :bill_name
      t.date :propose_date
      t.string :age
      t.json :response
      t.timestamps
    end
  end
end

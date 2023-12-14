class CreateResponseLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :response_logs do |t|
      t.string :msg
      t.integer :request_type, default: 0
      t.json :response
      t.timestamps
    end
  end
end

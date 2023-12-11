class CreateErrorLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :error_logs do |t|
      t.string :content
      t.integer :request_type
      t.json :response

      t.timestamps
    end
  end
end

class CreateErrorLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :error_logs do |t|
      t.string :msg
      t.jsonb :response
      t.timestamps
    end
  end
end

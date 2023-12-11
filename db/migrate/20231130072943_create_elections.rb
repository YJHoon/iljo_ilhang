class CreateElections < ActiveRecord::Migration[7.1]
  def change
    create_table :elections do |t|
      t.string :title
      t.string :vote_date
      t.string :sg_id
      t.string :sg_type_code

      t.timestamps
    end
  end
end

class CreateStays < ActiveRecord::Migration[7.0]
  def change
    create_table :stays do |t|
      t.references :studio, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date

      t.timestamps
    end
  end
end

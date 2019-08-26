class CreateStudies < ActiveRecord::Migration[6.0]
  def change
    create_table :studies do |t|
      t.string :name
      t.decimal :result
      t.string :unit
      t.references :result_sheet, foreign_key: true

      t.timestamps
    end
  end
end

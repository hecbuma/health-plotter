class CreateResultSheets < ActiveRecord::Migration[6.0]
  def change
    create_table :result_sheets do |t|
      t.string :doctor
      t.datetime :date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

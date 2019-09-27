class AddAttributesToResultSheets < ActiveRecord::Migration[6.0]
  def change
    add_column :result_sheets, :age, :integer
    add_column :result_sheets, :sex, :string
    add_column :result_sheets, :diagnosis, :string
    add_column :result_sheets, :patient, :string
  end
end

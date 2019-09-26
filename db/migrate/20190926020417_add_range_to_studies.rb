class AddRangeToStudies < ActiveRecord::Migration[6.0]
  def change
    add_column :studies, :range, :string
  end
end

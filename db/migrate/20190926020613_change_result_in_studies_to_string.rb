class ChangeResultInStudiesToString < ActiveRecord::Migration[6.0]
  def change
    change_column :studies, :result, :string
  end
end

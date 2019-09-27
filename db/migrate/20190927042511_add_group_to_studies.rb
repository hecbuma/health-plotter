class AddGroupToStudies < ActiveRecord::Migration[6.0]
  def change
    add_column :studies, :group, :string
  end
end

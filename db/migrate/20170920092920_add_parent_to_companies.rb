class AddParentToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :parent, :string
  end
end

class AddTypusToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :typus, :string
  end
end

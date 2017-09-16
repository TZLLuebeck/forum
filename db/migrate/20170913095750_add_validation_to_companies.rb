class AddValidationToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :validated, :boolean
  end
end

class ChangeDescriptionOnTables < ActiveRecord::Migration[5.1]
  def change
   change_column :companies, :description, :text 
   change_column :interests, :description, :text
  end
end
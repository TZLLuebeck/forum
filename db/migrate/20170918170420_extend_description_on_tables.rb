class ExtendDescriptionOnTables < ActiveRecord::Migration[5.1]
  def change
   change_column :companies, :description, :longtext 
   change_column :interests, :description, :longtext
  end
end
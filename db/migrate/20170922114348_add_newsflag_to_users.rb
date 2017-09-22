class AddNewsflagToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :news, :boolean, default: false
  end
end

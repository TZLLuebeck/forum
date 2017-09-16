class CreateInterests < ActiveRecord::Migration[5.1]
  def change
    create_table :interests do |t|
      t.integer :user_id
      t.boolean :general
      t.string :offer
      t.string :typus
      t.string :target
      t.string :title
      t.string :description
      t.string :category
      t.string :subcategory

      t.integer :contacts

      t.timestamps
    end
  end
end

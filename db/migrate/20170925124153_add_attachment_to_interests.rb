class AddAttachmentToInterests < ActiveRecord::Migration[5.1]
  def change
    add_column :interests, :attachment, :string
  end
end

class AddLoginToImage < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :login, :string
  end
end

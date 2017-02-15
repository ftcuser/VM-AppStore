class AddAmiConstraints < ActiveRecord::Migration[5.0]
  def change
    add_index :images, :ami, unique: true
  end
end

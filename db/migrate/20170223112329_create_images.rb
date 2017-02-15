class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.string :name
      t.string :description
      t.string :ami
      t.string :os

      t.timestamps
    end
  end
end

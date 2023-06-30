class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :name
      t.integer :quantity, default: 0
      t.decimal :price, precision: 8, scale: 2
      t.integer :multiverse_ids
      t.string :image_uris
      t.integer :user_id
      t.string :printed_name
      t.string :color_identity
      t.decimal :price_total, precision: 8, scale: 2

      t.timestamps
    end
  end
end

class CreateUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :urls do |t|
      t.string :original, null: false, unique: true
      t.string :shortened, null: false, unique: true
      t.references :user 
      t.timestamps

    end
    add_index :urls, :original
  end
end

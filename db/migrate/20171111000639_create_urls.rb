class CreateUrls < ActiveRecord::Migration[5.1]
  def change
    create_table :urls do |t|
      t.string :url
      t.string :short
      t.integer :visit_count, default: 0
    end

    add_index :urls, :url, unique: true
    add_index :urls, :short, unique: true
  end
end

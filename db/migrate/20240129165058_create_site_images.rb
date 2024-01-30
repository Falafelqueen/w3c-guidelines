class CreateSiteImages < ActiveRecord::Migration[7.0]
  def change
    create_table :site_images do |t|
      t.references :site_check, null: false, foreign_key: true
      t.string :url
      t.integer :size
      t.integer :size_kb
      t.string :format

      t.timestamps
    end
  end
end

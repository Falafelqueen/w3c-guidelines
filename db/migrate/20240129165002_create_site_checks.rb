class CreateSiteChecks < ActiveRecord::Migration[7.0]
  def change
    create_table :site_checks do |t|
      t.string :url, null: false
      t.timestamps
    end
  end
end

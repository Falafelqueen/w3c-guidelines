class CreateCriteria < ActiveRecord::Migration[7.0]
  def change
    create_table :criteria do |t|
      t.string :title
      t.string :text
      t.references :guideline, null: false, foreign_key: true

      t.timestamps
    end
  end
end

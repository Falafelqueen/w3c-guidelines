class CreateBenefits < ActiveRecord::Migration[7.0]
  def change
    create_table :benefits do |t|
      t.string :text
      t.integer :category
      t.references :guideline, foreign_key: true
      t.timestamps
    end
  end
end

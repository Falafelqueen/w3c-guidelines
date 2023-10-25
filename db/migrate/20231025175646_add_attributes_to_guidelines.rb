class AddAttributesToGuidelines < ActiveRecord::Migration[7.0]
  def change
    add_column :guidelines, :title, :string
    add_column :guidelines, :description, :text
    add_column :guidelines, :effort, :integer
    add_column :guidelines, :impact, :integer
    add_column :guidelines, :category, :integer
  end
end

class AddLinkToGuidelines < ActiveRecord::Migration[7.0]
  def change
    add_column :guidelines, :link_url, :string
  end
end

class ChangeSizeToFloat < ActiveRecord::Migration[7.0]
  def change
    change_column :site_images, :size, :float
  end
end

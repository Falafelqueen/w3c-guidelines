class SiteCheck < ApplicationRecord
  has_many :site_images

  def total_image_size
    site_images.sum(:size_kb)
  end


end

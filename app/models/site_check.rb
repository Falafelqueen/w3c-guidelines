class SiteCheck < ApplicationRecord
  has_many :site_images

  def total_image_size
    site_images.sum(:size_kb)
  end

  def size_in_kb
    size_kb * 0.01
  end
end

class SiteCheck < ApplicationRecord
  has_many :site_images, dependent: :destroy

  def total_image_size
    (site_images.sum(:size) * 0.001).round(2)
  end
end

class SiteCheck < ApplicationRecord
  has_many :site_images, dependent: :destroy

  validates :url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  def total_image_size
    site_images.sum(:size_kb).to_f
  end
end

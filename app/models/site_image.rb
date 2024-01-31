class SiteImage < ApplicationRecord
  belongs_to :site_check
  def size_in_kb
    (size * 0.001).round(2)
  end
end

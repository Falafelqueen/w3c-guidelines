class SiteImage < ApplicationRecord
  belongs_to :site_check
  def size_in_kb
    size_kb * 0.01
  end
end

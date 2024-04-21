module SiteChecksHelper
  def shorten_url_with_ellipsis(url, max_length = 40)
    return url if url.length <= max_length

    part_length = (max_length - 3) / 2 # 3 is for the ellipsis length
    "#{url[0...part_length]}...#{url[-part_length..]}"
  end

  def total_images_size_with_unit(size)
    if size < 1000
      "#{size}KB"
    else
      "#{(size / 1000).round(2)}MB"
    end
  end
end

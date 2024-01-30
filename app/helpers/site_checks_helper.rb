module SiteChecksHelper
  def shorten_url_with_ellipsis(url, max_length = 40)
    return url if url.length <= max_length

    part_length = (max_length - 3) / 2 # 3 is for the ellipsis length
    "#{url[0...part_length]}...#{url[-part_length..]}"
  end
end

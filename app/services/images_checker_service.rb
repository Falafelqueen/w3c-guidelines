require 'nokogiri'
require 'httparty'

class ImagesCheckerService
  def self.log_images(url)
    new(url).log_images
  end

  def initialize(url)
    Rails.logger.debug "Started image logging process"
    @url = url
  end

  def log_images
    # calculation +/- in line with results from webpage test and google dev tools
    html = fetch_html(@url)
    image_info = []
    total_size = 0
    resource_urls = extract_images_urls(html)

    resource_urls.each do |resource_url|
      puts resource_url
      image = fetch_image_info(resource_url)
      total_size += image[:size_kb]
      image_info << image
    end
    Rails.logger.debug "Total image count: #{image_info.length} | #{(total_size.to_f / 1.0.megabyte).round(2)}MB"
    {images: image_info, total_size: total_size}
  end

  private

  def fetch_html(url)
    Rails.logger.debug "Fetching url"
    response = HTTParty.get(url)
    response.body
  end

  def extract_images_urls(html)
    doc = Nokogiri::HTML(html)
    urls = []

    # Extract URLs from <link>, <script>, and <img> tags
    doc.css('img').each do |element|
      url = element['src']
      urls << URI.join(@url, url).to_s
    end

    urls.uniq
  end

  def fetch_image_info(url)
    response = HTTParty.get(url, follow_redirects: true)
    format = extract_image_format(response.headers["content-type"])
    puts "--------------"
    puts format
    puts "#{response.body.bytesize} bytes #{response.body.bytesize * 0.001}kb"
    puts "--------------"
    {
      url: url,
      size: response.body.bytesize,
      size_kb: (response.body.bytesize * 0.1),
      format: format
    }
  rescue StandardError => e
    Rails.logger.error "Failed to fetch resource: #{url}, error: #{e.message}"
    0
  end

  def extract_image_format(content_type)
    case content_type
    when /image\/jpeg/
      "JPEG"
    when /image\/png/
      "PNG"
    when /image\/gif/
      "GIF"
    when /image\/webp/
      "WebP"
    when /image\/svg\+xml/
      "SVG"
    else
      "Unknown"
    end
  end
end

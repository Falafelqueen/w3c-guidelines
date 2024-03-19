require 'nokogiri'
require 'httparty'
require 'uri'
require 'base64'

class ImagesChecker
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
      puts "resource url"
      puts resource_url
      image = fetch_image_info(resource_url)
      # skip fonts
      unless image[:format].upcase.in?(["WOFF","WOFF2","TTF","OTF","EOT"])
        total_size += image[:size]
        image_info << image
      end
    end
    Rails.logger.debug "Total image count: #{image_info.length} | #{(total_size.to_f / 1.0.megabyte).round(2)}MB"
    puts "Total image count: #{image_info.length} | #{(total_size.to_f / 1.0.megabyte).round(2)}MB"
    {images: image_info, total_size: total_size}
  end

  private

  def fetch_html(url)
    Rails.logger.debug "Fetching url"
    user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
    response = HTTParty.get(url, headers: {"User-Agent" => user_agent})
    response.body
  end

  def extract_images_urls(html)
    doc = Nokogiri::HTML(html)
    urls = []

    # Extract URLs from <img> tags
    doc.css('img').each do |element|
      url = element['src']
      urls << URI.join(@url, url).to_s
    end

    # Extract URLs from inline CSS background images
    doc.css('style').each do |element|
      puts "--------------"
      puts "CSS bcg"
      css_url = extract_css_background_url(element.text)
      puts css_url
      puts "-------------"
      urls << URI.join(@url, css_url).to_s if css_url
    end

    puts "----------------------"
    puts "Stylesheet"
    pp doc.css('link')
    puts "----------------------"
    # Getting all the links
    doc.css('link').each do |link|
      # Getting only css files
      if link.to_s.match?(/css/)
        css_url = URI.join(@url, link['href']).to_s if link['href']
        urls += extract_images_from_css(css_url) if css_url
      end
    end
    # selecting background images from inline styling

    urls.uniq
  end

  def fetch_image_info(url)
    puts "-------------------"
    puts "logging from fetch_image_info"
    puts url
    puts "-------------------"
    # for links
    if url.match?(/^http/)
      user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
      response = HTTParty.get(url, follow_redirects: true, headers: {"User-Agent" => user_agent})
      format = extract_image_format(response.headers["content-type"],url)

      puts "if url.match?(/^http/)"
      puts "content-length #{response.headers["content-length"]}"
      puts format
      puts "#{response.body.bytesize} bytes #{response.body.bytesize * 0.001}kb"
      puts "-------------------"
      {
        url: url,
        size: response.body.bytesize,
        format: format
      }
    else
      # svg
      if url.match?(/image\/svg\+xml/)
        {
          url: url,
          size: svg_byte_size(url),
          format: 'SVG'
        }
      else
      # don't break if one image is unknown
        {
          url: url,
          size: 0,
          format: 'Unknown'
        }
      end
    end

  rescue StandardError => e
    Rails.logger.error "Failed to fetch resource: #{url}, error: #{e.message}"
    0
  end

  def fetch_css(url)
    response = http_get(url)
    response.body
    rescue StandardError => e
    Rails.logger.error "Failed to fetch CSS file: #{url}, error: #{e.message}"
  end

  def extract_css_background_url(style)
    return nil unless style
    puts "Extracting css background url"
    # This regex looks for the url() pattern in CSS
    puts style
    puts "-----------------"
    match = style.match(/background-image:.*?url\((['"]?)(.*?)\1\)/)
    match ? match[2] : nil
  end

  def extract_images_from_css(css_url)
    puts "-----------------"
    puts "Extracting images from css file"
    puts css_url
    puts "-----------------"
    css_content = fetch_css(css_url)
    css_image_urls = css_content.scan(/background-image:.*?url\((['"]?)(.*?)\1\)/).map { |match| match[1] }
    css_image_urls.map { |url| URI.join(css_url, url).to_s }
  end

  def extract_image_format(content_type,url)
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
      # get the format from the url
      if url.match(/.*\.(.{3,5})$/)
        $1.upcase
      else
        "Unknown"
      end
    end
  end

  def svg_byte_size(data_url)
    if data_url.include?('base64')
      # Extract and decode Base64 SVG data
      encoded_data = data_url.split(',')[1]
      svg_data = Base64.decode64(encoded_data)
    else
      # URL-decode the SVG data
      encoded_data = data_url.split(',')[1]
      svg_data = URI.decode_www_form_component(encoded_data)
    end

    svg_data.bytesize
  end

  def http_get(url)
    user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
    HTTParty.get(url, headers: {"User-Agent" => user_agent})
  end
end

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
      total_size += image[:size]
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
       puts "--------------"
    puts "raw html"
    puts doc
      puts "--------------"
    # Extract URLs from <img> tags
    doc.css('img').each do |element|
      url = element['src']
      urls << URI.join(@url, url).to_s
    end

    # Extract URLs from inline CSS background images
    doc.css('style').each do |element|
      puts "--------------"
      puts "CSS bcg"
      puts element.text
      puts "-------------"
      css_url = extract_css_background_url(element.text)
      urls << URI.join(@url, css_url).to_s if css_url
    end

    puts "----------------------"
    puts "Stylesheet"
    puts doc.css('link[rel="stylesheet"]')
    puts "----------------------"
    # Getting bcg images from css files
    doc.css('link[rel="stylesheet"]').each do |link|
      puts "----------------"
      puts "css link"
      puts link
      puts "----------------"
      css_url = URI.join(@url, link['href']).to_s if link['href']
      urls += extract_images_from_css(css_url) if css_url
    end
    # selecting background images from inline styling

    urls.uniq
  end

  def fetch_image_info(url)
    # for links
    if url.match?(/^http/)
      response = HTTParty.get(url, follow_redirects: true)
      format = extract_image_format(response.headers["content-type"],url)

      puts "--------------"
      puts url
      puts format
      puts "#{response.body.bytesize} bytes #{response.body.bytesize * 0.001}kb"
      puts "--------------"
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
    response = HTTParty.get(url)
    response.body
    rescue StandardError => e
    Rails.logger.error "Failed to fetch CSS file: #{url}, error: #{e.message}"
    ""
  end

  def extract_css_background_url(style)
    return nil unless style

    # This regex looks for the url() pattern in CSS
    match = style.match(/url\((['"]?)(.*?)\1\)/)
    match ? match[2] : nil
  end

  def extract_images_from_css(css_url)
    css_content = fetch_css(css_url)
    css_image_urls = css_content.scan(/url\((['"]?)(.*?)\1\)/).map { |match| match[1] }
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
end

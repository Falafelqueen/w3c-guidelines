require 'json'

class JsImagesChecker
  def self.log_images(url)
    new(url).log_images
  end


  def initialize(url)
    Rails.logger.debug "Started image logging process"
    @url = url
  end

  def log_images
   script_path = Rails.root.join('node_scripts', 'image_checker.js')
   output = `node #{script_path} #{@url.shellescape}`
   begin
    image_info = JSON.parse(output)
    total_size = image_info.inject(0) { |sum, image| sum + image['size_kb'] }
    total_size_in_mb = (total_size / 1000).round(2)
    Rails.logger.debug "Total image count: #{image_info.length} | #{total_size_in_mb}MB"
    {images: image_info, total_size: total_size}
   rescue JSON::ParserError => e
     Rails.logger.error "Failed to parse JSON from image checker script: #{e.message}"
     nil
   end
  end
end

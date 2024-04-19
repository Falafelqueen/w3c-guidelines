require 'nokogiri'
require 'httparty'
require 'uri'
require 'base64'

class UnusedCssRemover
  include CssParser

  def initialize(url)
    @url = url
    @doc =  Nokogiri::HTML(fetch_html(@url))
    @used_css_selectors = []
    @used_css_declarations = []
  end

  # get all the css files

  def remove_unused_styles
    css_urls = fetch_css_urls
    css_urls.each do |css_url|
      get_used_css_selectors(css_url)
    end
  end

  # go throug the css files and try to find the elements in Nokogiri
  # if the element exists push the css selector somewhere -> used_css and also the style declarations


  private
  def get_used_css_selectors(css_url)
    puts "breaking here"
    parser = CssParser::Parser.new
    parser.load_uri!(css_url)
    parser.each_selector do |selector, declaration|
      # go through each selector
      # if there is an element that can be found with that selector
   puts "Processing selector: #{selector}"  # Debug output to see which selector is processed
    next if selector.match?(/[:@]/)

    begin
      element = @doc.css(selector)
      unless element.empty?
        @used_css_selectors << selector
        @used_css_declarations << declaration
      end
    rescue Nokogiri::CSS::SyntaxError => e
      puts "Handled CSS Syntax Error: #{e.message} for selector: #{selector}"
    end
      # add the selector to used_css_selectors
      # add the styles do declarations
    end
  end

  def fetch_html(url)
    Rails.logger.debug "Fetching url"
    user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
    response = HTTParty.get(url, headers: {"User-Agent" => user_agent})
    response.body
  end

  def fetch_css_urls
    css_urls = []
     @doc.css('link').each do |link|
      # Getting only css files
      if link.to_s.match?(/\.css/)
        css_url = URI.join(@url, link['href']).to_s if link['href']
        css_urls << css_url if css_url
      end
    end
    css_urls
  end

  def http_get(url)
    user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
    HTTParty.get(url, headers: {"User-Agent" => user_agent})
  end

end

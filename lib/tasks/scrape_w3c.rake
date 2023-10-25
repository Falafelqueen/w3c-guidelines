require 'nokogiri'
require 'open-uri'

namespace :scrape do
  desc "Scrape W3C sustainability page"
  task :w3c do
    url = 'https://w3c.github.io/sustyweb'
    html = URI.open(url)
    doc = Nokogiri::HTML(html)
    guidelines = [] # unnecessary
    doc.search('#user-experience-design section').each do |section|
      guideline_raw = section.attribute('id') && section.attribute('id').value
      guideline = guideline_raw && guideline_raw.split('-').join(' ').capitalize

      # get the guideline title

      guidelines << guideline if guideline

      # get the guideline description

      section.search('.header-wrapper + p').text

      section.search('.benefits li').each do |li|
        # get the guideline benefits
          benefit_text = li.text.split(':')[1..-1].join(':').strip
          benefit_category = li.search('strong').text.split(':').first
      end

      # get the guideline effort and impact
      # impact
      section.search('.rating dd').first && section.search('.rating dd').first.text
      # effort
      section.search('.rating dd')[1] && section.search('.rating dd')[1].text

      # get the criteria title and descriptions
       section.search('.notoc').each do |notoc|
        criteria_raw = notoc.search('[id^="success-criterion"]').present? && notoc.search('[id^="success-criterion"]').text.split('-')[1..-1].join('-').strip
        if criteria_raw.present?
          criteria = criteria_raw
          pp notoc.search('p').text
        end
      end
    end
  end
end

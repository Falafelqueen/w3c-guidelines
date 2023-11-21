# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'nokogiri'
require 'open-uri'

url = 'https://w3c.github.io/sustyweb'
html = URI.open(url)
doc = Nokogiri::HTML(html)

puts "Cleaning database..."

Benefit.destroy_all
Criterium.destroy_all
Guideline.destroy_all

# UX guidelines
puts "--------------------------------------------------------------"
puts "Creating UX guidelines..."
puts "--------------------------------------------------------------"

doc.search('#user-experience-design section').each do |section|
  guideline_raw = section.attribute('id') && section.attribute('id').value
  guideline = guideline_raw && guideline_raw.split('-').join(' ').capitalize

  if guideline
    # get the guideline title
    g = Guideline.new(title: guideline)

    # add link
    g.link_url = "#{url}/##{section.attribute('id').value}"

    # get the guideline description
    g.description = section.search('.header-wrapper + p').first.text

    section.search('.benefits li').each do |li|
      # get the guideline benefits
      benefit_text = li.text.split(':')[1..-1].join(':').strip
      benefit_category = li.search('strong').text.split(':').first
      Benefit.create(text: benefit_text, category: benefit_category, guideline: g)
    end

    # get the guideline effort and impact
    # impact
    impact =  section.search('.rating dd').first&.text
    g.impact = case impact
              when "Low" then 0
              when "Medium" then 1
              when "High" then 2
              end
    # effort
    effort = section.search('.rating dd')[1]&.text
    g.effort = case effort
              when "Low" then 0
              when "Medium" then 1
              when "High" then 2
              end
    # get the criteria title and descriptions
    section.search('.notoc').each do |notoc|
      criteria_raw = notoc.search('[id^="success-criterion"]').present? && notoc.search('[id^="success-criterion"]').text.split('-')[1..-1].join('-').strip
      if criteria_raw.present?
        criteria = criteria_raw
        text = notoc.search('p').text

        Criterium.create!(title: criteria, text: text, guideline: g)
      end
    end
    g.category = 0
    g.save!

    puts "Created #{g.title}"
  end
end

# Web dev guidelines
puts "--------------------------------------------------------------"
puts "Creating Web dev guidelines..."
puts "--------------------------------------------------------------"



doc.search('#web-development section').each do |section|
  guideline_raw = section.attribute('id') && section.attribute('id').value
  guideline = guideline_raw && guideline_raw.split('-').join(' ').capitalize

  if guideline
  # get the guideline title
    g = Guideline.new(title: guideline)
    g.link_url = "#{url}/##{section.attribute('id').value}"
    # get the guideline description

    g.description = section.search('.header-wrapper + p').first.text

    section.search('.benefits li').each do |li|
      # get the guideline benefits
      benefit_text = li.text.split(':')[1..-1].join(':').strip
      benefit_category = li.search('strong').text.split(':').first
      Benefit.create(text: benefit_text, category: benefit_category, guideline_id: g.id)
    end

    # get the guideline effort and impact
    # impact
    impact =  section.search('.rating dd').first&.text
    g.impact = case impact
              when "Low" then 0
              when "Medium" then 1
              when "High" then 2
              end
    # effort
    effort = section.search('.rating dd')[1]&.text
    g.effort = case effort
              when "Low" then 0
              when "Medium" then 1
              when "High" then 2
              end
    # get the criteria title and descriptions
    section.search('.notoc').each do |notoc|
      criteria_raw = notoc.search('[id^="success-criterion"]').present? && notoc.search('[id^="success-criterion"]').text.split('-')[1..-1].join('-').strip
      if criteria_raw.present?
        criteria = criteria_raw
        text = notoc.search('p').text

        Criterium.create!(title: criteria, text: text, guideline: g)
      end
    end
    g.category = 1
    g.save!

    puts "Created #{g.title}"
  end
end
puts "--------------------------------------------------------------"
puts "Creating hosting infrastructure and systems guidelines..."
puts "--------------------------------------------------------------"

doc.search('#hosting-infrastructure-and-systems section').each do |section|
  guideline_raw = section.attribute('id') && section.attribute('id').value
  guideline = guideline_raw && guideline_raw.split('-').join(' ').capitalize

  if guideline
  # get the guideline title
    g = Guideline.new(title: guideline)

    # add link

    g.link_url = "#{url}/##{section.attribute('id').value}"
    # get the guideline description

    g.description = section.search('.header-wrapper + p').first.text

    section.search('.benefits li').each do |li|
      # get the guideline benefits
      benefit_text = li.text.split(':')[1..-1].join(':').strip
      benefit_category = li.search('strong').text.split(':').first
      Benefit.create(text: benefit_text, category: benefit_category, guideline_id: g.id)
    end

    # get the guideline effort and impact
    # impact
    impact =  section.search('.rating dd').first&.text
    g.impact = case impact
              when "Low" then 0
              when "Medium" then 1
              when "High" then 2
              end
    # effort
    effort = section.search('.rating dd')[1]&.text
    g.effort = case effort
              when "Low" then 0
              when "Medium" then 1
              when "High" then 2
              end
    # get the criteria title and descriptions
    section.search('.notoc').each do |notoc|
      criteria_raw = notoc.search('[id^="success-criterion"]').present? && notoc.search('[id^="success-criterion"]').text.split('-')[1..-1].join('-').strip
      if criteria_raw.present?
        criteria = criteria_raw
        text = notoc.search('p').text

        Criterium.create!(title: criteria, text: text, guideline: g)
      end
    end
    g.category = 2
    g.save!

    puts "Created #{g.title}"
  end
end

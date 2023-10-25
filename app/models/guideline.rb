class Guideline < ApplicationRecord
  has_many :benefits
  has_many :criteria

  enum :category, %i[ux_design development hosting_and_infractructure]
  enum :effort, %i[low medium high], prefix: true
  enum :impact, %i[low medium high], prefix: true
end

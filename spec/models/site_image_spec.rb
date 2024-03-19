require 'rails_helper'

RSpec.describe SiteImage do
  describe "#size_in_kb" do
    it "returns the size in kilobites" do
      site_image = SiteImage.new(size: 13257)
      expect(site_image.size_in_kb).to eq(13.26)
    end
  end
end

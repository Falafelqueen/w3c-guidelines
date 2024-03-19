require 'rails_helper'

RSpec.describe ImagesChecker do
  describe ".log_images" do
    it "returns the total image size and the images" do
      VCR.use_cassette("images_checker") do
        images_info = ImagesChecker.log_images("https://www.google.com")
        expect(images_info[:total_size]).to eq(0.0)
        expect(images_info[:images].size).to eq(0)
      end
    end
  end
end

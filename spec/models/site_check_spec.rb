require "rails_helper"

RSpec.describe SiteCheck do
  describe "#total_image_size" do
    let(:site_check) { FactoryBot.create(:site_check) }
    let!(:site_image) { FactoryBot.create(:site_image, site_check: site_check, size: 13257) }
    let!(:site_image_2) { FactoryBot.create(:site_image, site_check: site_check, size: 250289) }

    it "returns the sumed image in kilobites" do
      expect(site_check.total_image_size).to eq(263.55)
    end
  end
end

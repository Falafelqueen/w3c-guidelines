FactoryBot.define do
  factory :site_image do
    site_check
    url {"https://genderjobs.org/assets/nemo_headshot-a15e3ebcdc9c64fd84d33b9b77eb7a5dcfb146a7edd2731d14958565ada7a177.jpg"}
    size {13257}
    format {"JPEG"}
  end

  factory :site_image_2, class: SiteCheck do
    site_check
    url {"https://genderjobs.org/assets/logo_small_white-9dd6efe8e351cf444fd21a74d77971d6ff5ae81c6d73d6d2c992fc89cee3259f.svg"}
    size {250289}
    format {"SVG"}
  end
end

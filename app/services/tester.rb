class Tester

  def initialize(url)
    @url = url
  end

  def test_puppeteer
    system("node #{Rails.root.join('node_scripts', 'image_checker.js')} #{@url}")
  end
end

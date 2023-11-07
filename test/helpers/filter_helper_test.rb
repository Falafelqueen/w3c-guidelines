require 'test_helper'

class FilterHelperTest < ActionView::TestCase

 test 'generate_tag_names for category UX' do
    params = { 'category' => ['ux_design']}
    expected_tag_names = ['UX 🧑‍🎨']

    assert_equal expected_tag_names, generate_tag_names(params)
  end

 test 'generate_tag_names for category Developemnt' do
    params = { 'category' => ['development']}
    expected_tag_names = ['UX 🧑‍🎨']

    assert_equal expected_tag_names, generate_tag_names(params)
  end
 test 'generate_tag_names for category Hosting and Infra' do
    params = { 'category' => ['ux_design']}
    expected_tag_names = ['UX 🧑‍🎨']

    assert_equal expected_tag_names, generate_tag_names(params)
  end

  test 'generate_tag_names for effort' do
    params = { 'effort' => ['low', 'medium', 'high'] }
    expected_tag_names = ['Low effort', 'Medium effort', 'High effort']

    assert_equal expected_tag_names, generate_tag_names(params)
  end

  test 'generate_tag_names for impact' do
    params = { 'impact' => ['small', 'medium', 'large'] }
    expected_tag_names = ['Small impact', 'Medium impact', 'Large impact']

    assert_equal expected_tag_names, generate_tag_names(params)
  end
end

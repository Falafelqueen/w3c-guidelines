require 'test_helper'

class FilterHelperTest < ActionView::TestCase

 test 'generate_tag_names for category' do
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
    params = { 'impact' => ['low', 'medium', 'high'] }
    expected_tag_names = ['Low impact', 'Medium impact', 'High impact']

    assert_equal expected_tag_names, generate_tag_names(params)
  end

  test 'generate_tag_names with multiple filters' do
    params = { 'impact' => ['low', 'medium', 'high'], 'category' => ['ux_design'], 'effort' => ['low'] }
    expected_tag_names = ['Low impact', 'Medium impact', 'High impact', 'UX 🧑‍🎨', 'Low effort']

    assert_equal expected_tag_names, generate_tag_names(params)
  end

  test 'map_category_name for development' do
    names = ["development"]
    expected = ["Development 👩‍💻"]

    assert_equal expected, map_category_name(names)
  end
end

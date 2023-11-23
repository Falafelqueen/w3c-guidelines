module FilterHelper
  def generate_tag_names(params)
    tag_names = params.map do |key, values|
      if key == 'category'
        map_category_name(values)
      elsif key == 'effort'
        values.map do |value|
          "#{value.capitalize} effort"
        end
      elsif key == 'impact'
        values.map do |value|
          "#{value.capitalize} impact"
        end
      end
    end

    tag_names.flatten
  end

  def map_category_name(names)
    names.map do |name|
      case name
      when 'ux_design'
        'UX 🧑‍🎨'
      when 'development'
        'Development 👩‍💻'
      when 'hosting_and_infrastructure'
        'Hosting & Infrastructure 👷'
      end
    end
  end
end





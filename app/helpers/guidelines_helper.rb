module GuidelinesHelper
  def card_class(guideline)
    case guideline.category
    when 'ux_design' then "card--ux-design"
    when 'development' then "card--development"
    when 'hosting_and_infrastructure' then "card--hosting-and-infrastructure"
    when 'business_and_management' then "card--business-and-management"
    end
  end

  def guideline_effort(guideline)
    case guideline.effort
    when 'low' then '<p class="card__bottom--right">🦾</p>'
    when 'medium' then '<p class="card__bottom--right">🦾🦾</p>'
    when 'high' then '<p class="card__bottom--right">🦾🦾🦾</p>'
    end
  end


  def group_size(guidelines_count)
    # receives a number and returns a group size that is used for deciding the n of columns
    if guidelines_count < 5
      1
    elsif guidelines_count < 10
      2
    elsif guidelines_count <= 15
      4
    elsif guidelines_count <= 20
      5
    elsif guidelines_count < 30
      7
    elsif guidelines_count < 40
      9
    elsif guidelines_count < 50
      12
    elsif guidelines_count < 60
      15
    else
      18
    end
  end
end

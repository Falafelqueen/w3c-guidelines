class GuidelinesController < ApplicationController
  include Pagy::Backend

  def index
    @guidelines = Guideline.includes(:criteria)

    @guidelines = @guidelines.where(impact: params[:impact]) if params[:impact].present?
    @guidelines = @guidelines.where(effort: params[:effort]) if params[:effort].present?
    @guidelines = @guidelines.where(category: params[:category]) if params[:category].present?

    if params[:sort_by]
      @guidelines = case params[:sort_by]
      when 'low_effort'
        @guidelines.order(:effort)
      when 'high_impact'
        @guidelines.order(impact: :desc)
      when 'high_effort'
        @guidelines.order(effort: :desc)
      when 'low_impact'
        @guidelines.order(:impact)
      end
    end

    @pagy, @guidelines = pagy(@guidelines, items: set_items_count_by_device_width)

    respond_to do |f|
      f.html
      f.turbo_stream
    end
  end

  private

  def set_items_count_by_device_width
    count = cookies[:device].to_i
    if count >= 1080
      20
    elsif count > 900
      16
    elsif count > 700
      12
    else
      8
    end
  end
end

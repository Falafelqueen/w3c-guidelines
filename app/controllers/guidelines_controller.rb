class GuidelinesController < ApplicationController
  def index
    @guidelines = Guideline.includes(:criteria).order(impact: :desc)

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

    respond_to do |f|
      f.html
      f.turbo_stream
    end
  end
end

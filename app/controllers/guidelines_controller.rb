class GuidelinesController < ApplicationController
  def index
    @guidelines = Guideline.order(impact: :desc)

    @guidelines = @guidelines.where(impact: params[:impact]) if params[:impact].present?
    @guidelines = @guidelines.where(effort: params[:effort]) if params[:effort].present?
    @guidelines = @guidelines.where(category: params[:category]) if params[:category].present?
  end
end

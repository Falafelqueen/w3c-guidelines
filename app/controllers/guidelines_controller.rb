class GuidelinesController < ApplicationController
  def index
    @guidelines = Guideline.all
  end
end

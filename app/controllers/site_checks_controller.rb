class SiteChecksController < ApplicationController
  def new
    @site = SiteCheck.new
  end

  def create
    url = params[:site_check][:url]
    @site = SiteCheck.find_by(url: url)
    unless @site
      @site =  SiteCheck.new(site_check_params)

      render :new and return unless @site.valid?

      images_info = JsImagesChecker.log_images(@site.url)
      @total_image_size = images_info[:total_size]
      images_info[:images].each do |image|
        @site.site_images << SiteImage.new(image)
      end
      @site.save!
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def site_check_params
    params.require(:site_check).permit(:url)
  end
end

require "csv"
class ImagesExportController < ApplicationController
  def new
    site = SiteCheck.find(params[:site_check_id])
    respond_to do |format|
      format.csv do
        csv_data = CSV.generate(quote_char: '"', headers: true, col_sep: ';', quote_empty: false) do |csv|
          csv << ["Image url", "Format", "Size in KB"]
          site.site_images.each do |image|
            csv << [image.url, image.format, image.size_kb]
          end
        end
        send_data csv_data, type: 'text/csv', filename: "#{site.id}.csv", disposition: :attachment
      end
    end
  end
end

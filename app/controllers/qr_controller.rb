class QrController < ApplicationController
  def show
    host = request.base_url
    url = "#{host}/r/#{params[:restaurant_slug]}/t/#{params[:table_code]}"
    png = RQRCode::QRCode.new(url).as_png(size: 360)
    send_data png.to_s, type: "image/png", disposition: "inline"
  end
end

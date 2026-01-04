class Admin::QrCodesController < ApplicationController
  before_action :authenticate_staff!
  before_action :require_admin

  def index
    @restaurants = Restaurant.includes(:tables).all
    @selected_restaurant = if params[:restaurant_id]
      Restaurant.find(params[:restaurant_id])
    else
      @restaurants.first
    end
  end

  def show
    @table = Table.find(params[:id])
    @restaurant = @table.restaurant
    @url = menu_url(restaurant_slug: @restaurant.slug, table_code: @table.code, host: request.host_with_port)
    @qr_url = qr_path(restaurant_slug: @restaurant.slug, table_code: @table.code, format: :png)
  end

  def download
    table = Table.find(params[:id])
    url = menu_url(restaurant_slug: table.restaurant.slug, table_code: table.code, host: request.host_with_port)
    
    case params[:format]
    when 'png'
      qr = RQRCode::QRCode.new(url)
      png = qr.as_png(
        resize_gte_to: false,
        resize_exactly_to: false,
        fill: 'white',
        color: 'black',
        size: 500,
        border_modules: 4
      )
      send_data png.to_s, 
        type: 'image/png', 
        disposition: 'attachment', 
        filename: "table_#{table.code}_qr.png"
    when 'svg'
      qr = RQRCode::QRCode.new(url)
      svg = qr.as_svg(
        color: '000',
        shape_rendering: 'crispEdges',
        module_size: 6,
        standalone: true
      )
      send_data svg, 
        type: 'image/svg+xml', 
        disposition: 'attachment', 
        filename: "table_#{table.code}_qr.svg"
    else
      redirect_to admin_qr_codes_path, alert: 'Invalid format'
    end
  end

  def download_all
    restaurant = Restaurant.find(params[:restaurant_id])
    
    require 'zip'
    require 'stringio'
    
    zip_data = Stringio.new
    Zip::OutputStream.write_buffer(zip_data) do |zip|
      restaurant.tables.each do |table|
        url = menu_url(restaurant_slug: restaurant.slug, table_code: table.code, host: request.host_with_port)
        qr = RQRCode::QRCode.new(url)
        
        # Add PNG
        png = qr.as_png(size: 500, border_modules: 4)
        zip.put_next_entry("#{table.label}_#{table.code}.png")
        zip.write png.to_s
        
        # Add SVG
        svg = qr.as_svg(module_size: 6, standalone: true)
        zip.put_next_entry("#{table.label}_#{table.code}.svg")
        zip.write svg
      end
    end
    
    zip_data.rewind
    send_data zip_data.read, 
      type: 'application/zip', 
      disposition: 'attachment', 
      filename: "#{restaurant.slug}_qr_codes.zip"
  end

  private

  def require_admin
    redirect_to main_app.root_path, alert: 'Access denied.' unless current_staff&.admin?
  end
end

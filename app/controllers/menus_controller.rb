class MenusController < ApplicationController
  before_action :set_locale
  skip_before_action :verify_authenticity_token, only: [:upsell]
  
  def show
    @restaurant = Restaurant.find_by!(slug: params[:restaurant_slug])
    @table = @restaurant.tables.find_by!(code: params[:table_code])
    @categories = @restaurant.menu_categories.includes(:menu_items).order(:position)
  end

  def upsell
    restaurant = Restaurant.find_by!(slug: params[:restaurant_slug])
    item_ids = Array(params[:item_ids]).map(&:to_i)
    items = Upsell.for_cart(item_ids, restaurant: restaurant)
    render json: items.map { |i| { id: i.id, name: i.name, price_cents: i.price_cents, image_url: i.image_url } }
  end
  
  private
  
  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end
end

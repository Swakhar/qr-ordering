class MenusController < ApplicationController
  def show
    @restaurant = Restaurant.find_by!(slug: params[:restaurant_slug])
    @table = @restaurant.tables.find_by!(code: params[:table_code])
    @categories = @restaurant.menu_categories.includes(:menu_items).order(:position)
  end
end

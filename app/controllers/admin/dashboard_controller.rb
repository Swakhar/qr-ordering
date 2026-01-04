class Admin::DashboardController < ApplicationController
  before_action :authenticate_staff!
  before_action :require_admin

  def index
    @restaurants = Restaurant.all
    @selected_restaurant = if params[:restaurant_id]
      Restaurant.find(params[:restaurant_id])
    else
      @restaurants.first
    end

    return unless @selected_restaurant

    # Date range filter
    @start_date = params[:start_date]&.to_date || 30.days.ago.to_date
    @end_date = params[:end_date]&.to_date || Date.today

    # Orders in date range
    @orders = @selected_restaurant.orders
      .where(created_at: @start_date.beginning_of_day..@end_date.end_of_day)

    # Revenue statistics
    @total_revenue = @orders.sum(:total_cents) / 100.0
    @total_orders = @orders.count
    @average_order_value = @total_orders > 0 ? @total_revenue / @total_orders : 0
    
    # Payment statistics
    @total_paid = @orders.sum(:paid_cents) / 100.0
    @pending_payment = (@orders.sum(:total_cents) - @orders.sum(:paid_cents)) / 100.0
    
    # Status breakdown
    @orders_by_status = @orders.group(:status).count
    
    # Daily revenue chart data
    @daily_revenue = @orders
      .group("DATE(created_at)")
      .sum(:total_cents)
      .transform_values { |v| v / 100.0 }
      .sort_by { |date, _| date }
    
    # Top selling items
    @top_items = OrderItem
      .joins(order: :restaurant)
      .where(orders: { restaurant_id: @selected_restaurant.id, created_at: @start_date.beginning_of_day..@end_date.end_of_day })
      .group(:name_snapshot)
      .select('name_snapshot, SUM(qty) as total_qty, SUM(price_cents * qty) as total_revenue')
      .order('total_revenue DESC')
      .limit(10)
    
    # Recent orders
    @recent_orders = @selected_restaurant.orders
      .includes(:table, :order_items)
      .order(created_at: :desc)
      .limit(10)
  end

  private

  def require_admin
    redirect_to main_app.root_path, alert: 'Access denied.' unless current_staff&.admin?
  end
end

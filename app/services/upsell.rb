class Upsell
  # Given a list of item_ids in cart, return up to 3 suggestions using rule-based logic
  def self.for_cart(item_ids, restaurant:)
    return [] if item_ids.blank?
    
    cart_items = MenuItem.active.where(id: item_ids).includes(:menu_category)
    cart_category_names = cart_items.map { |i| i.menu_category.name.downcase }.uniq
    
    # Rule-based logic: suggest complementary items
    suggestions = []
    
    # Rule 1: If cart has mains but no drinks, suggest drinks
    if has_category?(cart_category_names, ['main', 'entrée', 'entree', 'hauptspeise']) && 
       !has_category?(cart_category_names, ['drink', 'beverage', 'getränke', 'getranke'])
      suggestions += get_items_from_categories(restaurant, ['drink', 'beverage', 'getränke', 'getranke'], exclude_ids: item_ids)
    end
    
    # Rule 2: If cart has mains but no sides, suggest sides
    if has_category?(cart_category_names, ['main', 'entrée', 'entree', 'hauptspeise']) && 
       !has_category?(cart_category_names, ['side', 'beilage', 'beilagen'])
      suggestions += get_items_from_categories(restaurant, ['side', 'beilage', 'beilagen'], exclude_ids: item_ids)
    end
    
    # Rule 3: If cart has food but no dessert, suggest desserts
    if (has_category?(cart_category_names, ['main', 'appetizer', 'starter', 'hauptspeise', 'vorspeise']) || suggestions.any?) && 
       !has_category?(cart_category_names, ['dessert', 'sweet', 'nachspeise', 'nachtisch'])
      suggestions += get_items_from_categories(restaurant, ['dessert', 'sweet', 'nachspeise', 'nachtisch'], exclude_ids: item_ids)
    end
    
    # Rule 4: Use item-specific upsell targets
    cart_items.each do |item|
      if item.upsell_targets.present? && item.upsell_targets.is_a?(Array)
        item.upsell_targets.each do |target|
          suggestions += get_items_from_categories(restaurant, [target], exclude_ids: item_ids)
        end
      end
    end
    
    # Return unique suggestions, limit to 3, prioritize by price (higher first)
    suggestions.uniq.sort_by(&:price_cents).reverse.take(3)
  end

  private

  def self.has_category?(category_names, keywords)
    category_names.any? { |cat| keywords.any? { |kw| cat.include?(kw) } }
  end

  def self.get_items_from_categories(restaurant, keywords, exclude_ids:)
    MenuItem.joins(:menu_category)
      .where(menu_categories: { restaurant_id: restaurant.id })
      .where("LOWER(menu_categories.name) LIKE ANY (ARRAY[?])", keywords.map { |k| "%#{k}%" })
      .where(is_active: true)
      .where.not(id: exclude_ids)
      .limit(3)
      .to_a
  end
end

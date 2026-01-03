# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding database..."

# Clean existing data in development
if Rails.env.development?
  puts "🧹 Cleaning existing data..."
  OrderItem.delete_all
  Payment.delete_all
  Order.delete_all
  MenuItem.delete_all
  MenuCategory.delete_all
  Table.delete_all
  Restaurant.delete_all
  Staff.delete_all
end

# Create Admin Staff
puts "👤 Creating staff..."
admin = Staff.find_or_create_by!(email: "admin@restaurant.com") do |s|
  s.password = "password123"
  s.password_confirmation = "password123"
  s.admin = true
end
puts "   ✓ Admin created: #{admin.email}"

# Create Restaurant
puts "🏪 Creating restaurant..."
restaurant = Restaurant.find_or_create_by!(slug: "gasthaus-bavaria") do |r|
  r.name = "Gasthaus Bavaria"
  r.currency = "EUR"
  r.vat_rate = 19.0
  r.address = "Marienplatz 8, 80331 München, Germany"
end
puts "   ✓ Restaurant: #{restaurant.name}"

# Create Tables
puts "🪑 Creating tables..."
tables = []
8.times do |i|
  table = restaurant.tables.find_or_create_by!(label: "Table #{i + 1}") do |t|
    t.code = "TBL#{sprintf('%03d', i + 1)}"
  end
  tables << table
end
puts "   ✓ Created #{tables.count} tables"

# Menu Categories
puts "📋 Creating menu categories..."
categories = {
  appetizers: restaurant.menu_categories.find_or_create_by!(name: "Vorspeisen / Appetizers", position: 1),
  mains: restaurant.menu_categories.find_or_create_by!(name: "Hauptgerichte / Main Courses", position: 2),
  sides: restaurant.menu_categories.find_or_create_by!(name: "Beilagen / Sides", position: 3),
  drinks: restaurant.menu_categories.find_or_create_by!(name: "Getränke / Beverages", position: 4),
  desserts: restaurant.menu_categories.find_or_create_by!(name: "Nachspeisen / Desserts", position: 5)
}
puts "   ✓ Created #{categories.count} categories"

# Menu Items
puts "🍽️  Creating menu items..."

# Appetizers
appetizers_data = [
  {
    name: "Brezelsuppe / Pretzel Soup",
    description: "Traditional Bavarian pretzel soup with cream and chives",
    price_cents: 790,
    allergens: ["gluten", "dairy"],
    image_url: "https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400",
    upsell_targets: [],
    is_active: true
  },
  {
    name: "Obatzda",
    description: "Bavarian cheese spread with onions, paprika, and caraway",
    price_cents: 890,
    allergens: ["dairy"],
    image_url: "https://images.unsplash.com/photo-1452195100486-9cc805987862?w=400",
    upsell_targets: ["drinks"],
    is_active: true
  },
  {
    name: "Leberkäse / Meat Loaf",
    description: "Bavarian meat loaf served with sweet mustard",
    price_cents: 690,
    allergens: ["gluten", "eggs"],
    image_url: "https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=400",
    upsell_targets: ["drinks", "sides"],
    is_active: true
  }
]

appetizers_data.each do |item|
  categories[:appetizers].menu_items.find_or_create_by!(name: item[:name]) do |mi|
    mi.description = item[:description]
    mi.price_cents = item[:price_cents]
    mi.allergens = item[:allergens]
    mi.image_url = item[:image_url]
    mi.upsell_targets = item[:upsell_targets]
    mi.is_active = item[:is_active]
  end
end

# Main Courses
mains_data = [
  {
    name: "Wiener Schnitzel",
    description: "Breaded veal cutlet served with lemon and potato salad",
    price_cents: 1890,
    allergens: ["gluten", "eggs"],
    image_url: "https://images.unsplash.com/photo-1600891964599-f61ba0e24092?w=400",
    upsell_targets: ["drinks", "sides"],
    is_active: true
  },
  {
    name: "Schweinshaxe / Pork Knuckle",
    description: "Crispy roasted pork knuckle with dark beer sauce",
    price_cents: 1990,
    allergens: [],
    image_url: "https://images.unsplash.com/photo-1432139555190-58524dae6a55?w=400",
    upsell_targets: ["drinks", "sides"],
    is_active: true
  },
  {
    name: "Käsespätzle / Cheese Noodles",
    description: "Homemade egg noodles with melted cheese and crispy onions",
    price_cents: 1290,
    allergens: ["gluten", "dairy", "eggs"],
    image_url: "https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400",
    upsell_targets: ["drinks", "sides"],
    is_active: true
  },
  {
    name: "Sauerbraten",
    description: "Marinated beef roast with red cabbage and dumplings",
    price_cents: 1790,
    allergens: ["gluten"],
    image_url: "https://images.unsplash.com/photo-1544025162-d76694265947?w=400",
    upsell_targets: ["drinks"],
    is_active: true
  },
  {
    name: "Forelle Müllerin / Trout",
    description: "Pan-fried trout with butter, almonds, and parsley potatoes",
    price_cents: 1690,
    allergens: ["fish", "nuts", "dairy"],
    image_url: "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400",
    upsell_targets: ["drinks"],
    is_active: true
  }
]

mains_data.each do |item|
  categories[:mains].menu_items.find_or_create_by!(name: item[:name]) do |mi|
    mi.description = item[:description]
    mi.price_cents = item[:price_cents]
    mi.allergens = item[:allergens]
    mi.image_url = item[:image_url]
    mi.upsell_targets = item[:upsell_targets]
    mi.is_active = item[:is_active]
  end
end

# Sides
sides_data = [
  {
    name: "Kartoffelsalat / Potato Salad",
    description: "Traditional Bavarian potato salad with vinegar dressing",
    price_cents: 490,
    allergens: [],
    image_url: "https://images.unsplash.com/photo-1625944230945-1b7dd3b949ab?w=400",
    upsell_targets: [],
    is_active: true
  },
  {
    name: "Rotkohl / Red Cabbage",
    description: "Sweet and sour red cabbage with apples",
    price_cents: 390,
    allergens: [],
    image_url: "https://images.unsplash.com/photo-1598030886026-26c2e562f3b7?w=400",
    upsell_targets: [],
    is_active: true
  },
  {
    name: "Semmelknödel / Bread Dumplings",
    description: "Traditional bread dumplings",
    price_cents: 490,
    allergens: ["gluten", "eggs"],
    image_url: "https://images.unsplash.com/photo-1608835291093-ef4efa6a948c?w=400",
    upsell_targets: [],
    is_active: true
  }
]

sides_data.each do |item|
  categories[:sides].menu_items.find_or_create_by!(name: item[:name]) do |mi|
    mi.description = item[:description]
    mi.price_cents = item[:price_cents]
    mi.allergens = item[:allergens]
    mi.image_url = item[:image_url]
    mi.upsell_targets = item[:upsell_targets]
    mi.is_active = item[:is_active]
  end
end

# Beverages
drinks_data = [
  {
    name: "Augustiner Helles 0.5L",
    description: "Munich's finest lager beer",
    price_cents: 490,
    allergens: ["gluten"],
    image_url: "https://images.unsplash.com/photo-1608270586620-248524c67de9?w=400",
    upsell_targets: [],
    is_active: true
  },
  {
    name: "Weißbier 0.5L",
    description: "Traditional Bavarian wheat beer",
    price_cents: 490,
    allergens: ["gluten"],
    image_url: "https://images.unsplash.com/photo-1535958636474-b021ee887b13?w=400",
    upsell_targets: [],
    is_active: true
  },
  {
    name: "Apfelschorle 0.3L",
    description: "Apple juice spritzer",
    price_cents: 350,
    allergens: [],
    image_url: "https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400",
    upsell_targets: [],
    is_active: true
  },
  {
    name: "Coca-Cola 0.3L",
    description: "Classic Coca-Cola",
    price_cents: 320,
    allergens: [],
    image_url: "https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400",
    upsell_targets: [],
    is_active: true
  },
  {
    name: "Mineralwasser 0.5L",
    description: "Sparkling mineral water",
    price_cents: 290,
    allergens: [],
    image_url: "https://images.unsplash.com/photo-1523362628745-0c100150b504?w=400",
    upsell_targets: [],
    is_active: true
  }
]

drinks_data.each do |item|
  categories[:drinks].menu_items.find_or_create_by!(name: item[:name]) do |mi|
    mi.description = item[:description]
    mi.price_cents = item[:price_cents]
    mi.allergens = item[:allergens]
    mi.image_url = item[:image_url]
    mi.upsell_targets = item[:upsell_targets]
    mi.is_active = item[:is_active]
  end
end

# Desserts
desserts_data = [
  {
    name: "Apfelstrudel",
    description: "Apple strudel with vanilla ice cream",
    price_cents: 690,
    allergens: ["gluten", "dairy", "eggs"],
    image_url: "https://images.unsplash.com/photo-1568571780765-9276ac8b75a2?w=400",
    upsell_targets: [],
    is_active: true
  },
  {
    name: "Schwarzwälder Kirschtorte",
    description: "Black Forest cake with cherries and cream",
    price_cents: 790,
    allergens: ["gluten", "dairy", "eggs"],
    image_url: "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400",
    upsell_targets: [],
    is_active: true
  },
  {
    name: "Kaiserschmarrn",
    description: "Fluffy shredded pancake with plum compote",
    price_cents: 890,
    allergens: ["gluten", "dairy", "eggs"],
    image_url: "https://images.unsplash.com/photo-1568571780765-9276ac8b75a2?w=400",
    upsell_targets: [],
    is_active: true
  }
]

desserts_data.each do |item|
  categories[:desserts].menu_items.find_or_create_by!(name: item[:name]) do |mi|
    mi.description = item[:description]
    mi.price_cents = item[:price_cents]
    mi.allergens = item[:allergens]
    mi.image_url = item[:image_url]
    mi.upsell_targets = item[:upsell_targets]
    mi.is_active = item[:is_active]
  end
end

puts "   ✓ Created #{MenuItem.count} menu items"

puts "\n✅ Seeding complete!"
puts "\n📊 Summary:"
puts "   • 1 Restaurant: #{restaurant.name}"
puts "   • #{tables.count} Tables"
puts "   • #{categories.count} Menu Categories"
puts "   • #{MenuItem.count} Menu Items"
puts "   • 1 Admin Staff: #{admin.email} / password123"
puts "\n🔗 Test the menu at: http://localhost:3007/r/gasthaus-bavaria/t/TBL001"

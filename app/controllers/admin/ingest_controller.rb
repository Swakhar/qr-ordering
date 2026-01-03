class Admin::IngestController < ApplicationController
  before_action :authenticate_staff!
  def new; end

  def create
    restaurant = Restaurant.find(params[:restaurant_id])
    category   = restaurant.menu_categories.find_or_create_by!(name: params[:category] || "Neu")
    client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:openai, :api_key))

    prompt = <<~TXT
      Convert the following raw menu text into JSON array of items with keys:
      name (string), description (string), price_cents (int), allergens (array of strings like ["gluten","lactose"]).
      Prices may be in EUR with comma decimals; convert to cents. Only output JSON.
      TEXT:
      #{params[:raw]}
    TXT

    r = client.chat(parameters: { model: "gpt-4o-mini", messages: [{ role: "user", content: prompt }] })
    json = JSON.parse(r.dig("choices",0,"message","content"))
    created = []
    json.each do |row|
      created << MenuItem.create!(
        menu_category: category,
        name: row["name"],
        description: row["description"].to_s,
        price_cents: row["price_cents"].to_i,
        allergens: Array(row["allergens"]),
        is_active: true
      )
    end
    redirect_to admin_root_path, notice: "Erstellt: #{created.size} Artikel"
  rescue => e
    redirect_to new_admin_ingest_path, alert: "Import fehlgeschlagen: #{e.message}"
  end
end

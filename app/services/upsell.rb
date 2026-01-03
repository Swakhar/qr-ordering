class Upsell
  # Given a list of item_ids in cart, return 3 suggestions
  def self.for_cart(item_ids, restaurant:)
    base = MenuItem.active.where(id: item_ids).pluck(:id, :name, :description)
    # 1) Vector similarity against all items in the same restaurant
    query = base.map { |(_,n,d)| "#{n}. #{d}" }.join(" & ")
    vec = embed(query)
    vector_matches = MenuItem.joins(menu_category: :restaurant)
      .where(menu_categories: { restaurant_id: restaurant.id })
      .where.not(id: item_ids)
      .order(Arel.sql("embedding <-> '#{vector_literal(vec)}'"))
      .limit(8)
    # 2) LLM rerank simple (names only) — optional to keep cheap
    reranked = rerank_llm(base, vector_matches)
    reranked.take(3)
  end

  def self.embed(text)
    client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:openai, :api_key))
    resp = client.embeddings(parameters: { model: "text-embedding-3-small", input: text })
    resp["data"][0]["embedding"]
  end

  def self.vector_literal(arr) = "[" + arr.map { |x| format("%.6f", x) }.join(",") + "]"

  def self.rerank_llm(cart, candidates)
    client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:openai, :api_key))
    cart_names = cart.map { |(_,n,_)| n }
    cand_lines = candidates.map { |c| "#{c.id}:: #{c.name}" }.join("\n")
    prompt = <<~TXT
      A guest ordered: #{cart_names.join(", ")}.
      From the following candidates, pick the BEST 3 complementary upsells (IDs only), focusing on sides/drinks/desserts:
      #{cand_lines}
      Answer as a comma-separated list of IDs only.
    TXT
    r = client.chat(parameters: { model: "gpt-4o-mini", messages: [{ role: "user", content: prompt }] })
    ids = r.dig("choices",0,"message","content").to_s.scan(/\d+/).map(&:to_i)
    candidates.select { |c| ids.include?(c.id) } + (candidates - candidates.select { |c| ids.include?(c.id) })
  rescue
    candidates
  end
end

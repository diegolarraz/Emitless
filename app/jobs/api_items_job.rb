class ApiItemsJob < ApplicationJob
  require 'net/http'
  require 'csv'
  queue_as :default


  def perform
    csv_text = File.read(Rails.root.join('db', 'generic_items.csv'))
    csv = CSV.parse(csv_text, :headers => true)
    data = []
    csv.each do |row|
      data << row.to_hash
    end
    data.each do |item|
      uri = URI("https://dev.tescolabs.com/grocery/products/?query=#{item[:name.to_s]}&offset=0&limit=1")
      request = Net::HTTP::Get.new(uri.request_uri)
      request['Ocp-Apim-Subscription-Key'] = 'f28897cdf4944da9882e36b95508f910'
      request.body = ""
      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
      end
      items_hash = JSON.parse(response.body)
      items_hash['uk']['ghs']['products']['results'].each do |result|
      # emissions = (rand() * 100).round
      # name = result['name'].gsub(/\s\d+.+(g|kg)\z/i, ""),
        # binding.pry
        # if result['ContentsQuantity'] == nil
        #   binding.pry
        # end
        # binding.pry
        new_item = Item.new(
          generic_name: item[:name.to_s],
          generic_unit: item[:unit.to_s],
          generic_quantity: item[:quantity.to_s],
          category: item[:category.to_s],
          sub_category: item[:sub_category.to_s],
          image: item[:image.to_s],
          seasonal: item[:seasonal.to_s],
          name: result['name'].gsub(/\s\d+.+(g|kg)\z/i, ""),
          price: result['price'],
          quantity: result['ContentsQuantity'].to_i,
          unit: result['ContentsMeasureType'].downcase,
          retailer: 'Tesco',
          # emission: emissions
          )
        if new_item.unit == "sngl"
          new_item.unit = "each"
          # binding.pry
        end
        if new_item.category == ("meat" || "seafood") && new_item.unit == "g"
          new_item.emission = (rand(0.06..0.1) * new_item.quantity.to_i).round()
        elsif new_item.category == ("meat" || "seafood") && new_item.unit == "kg"
          new_item.emission = (rand(0.06..0.1) * new_item.quantity.to_f * 1000).round()
        elsif new_item.category == ("meat" || "seafood") && new_item.unit == "each"
          new_item.emission = (rand(0.06..0.1) * new_item.quantity.to_i * 150).round()
        elsif new_item.category == "fruit" && new_item.unit == "each"
          new_item.emission = (rand(0.02..0.06) * new_item.quantity.to_f * 100).round()
        elsif new_item.category == "vegetable" && new_item.unit == "each"
          new_item.emission = (rand(0.02..0.06) * new_item.quantity.to_f * 250).round()
        elsif new_item.unit == "g"
          new_item.emission = (rand(0.02..0.06) * new_item.quantity.to_i).round()
        elsif new_item.unit == "kg"
          new_item.emission = (rand(0.02..0.06) * new_item.quantity.to_f * 1000).round()
        end
        if new_item.emission.nil?
          new_item.name = nil
        end
        new_item.save
      end
    end
    # Do something later
  end

end

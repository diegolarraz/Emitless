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
      uri = URI("https://dev.tescolabs.com/grocery/products/?query=#{item[:name.to_s]}&offset=0&limit=3")
      request = Net::HTTP::Get.new(uri.request_uri)
      request['Ocp-Apim-Subscription-Key'] = 'f28897cdf4944da9882e36b95508f910'
      request.body = ""
      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
      end
      items_hash = JSON.parse(response.body)
      items_hash['uk']['ghs']['products']['results'].each do |result|
      emissions = (rand() * 10).round(2)
        # binding.pry
        # if result['ContentsQuantity'] == nil
        #   binding.pry
        # end
        new_item = Item.new(
          generic_name: item[:name.to_s],
          generic_unit: item[:unit.to_s],
          generic_quantity: item[:quantity.to_s],
          category: item[:category.to_s],
          sub_category: item[:sub_category.to_s],
          image: item[:image.to_s],
          seasonal: item[:seasonal.to_s],
          name: result['name'],
          price: result['price'],
          quantity: result['ContentsQuantity'].to_i,
          retailer: 'Tesco',
          emission: emissions
          )
        new_item.save
      end
    end
    # Do something later
  end

end

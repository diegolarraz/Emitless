class ApiItemsJob < ApplicationJob
  require 'net/http'
  queue_as :default

  def perform
    GenericItem.all.map{|r| r.name}.uniq.each do |item|
      uri = URI("https://dev.tescolabs.com/grocery/products/?query=#{item}&offset=0&limit=3")
      request = Net::HTTP::Get.new(uri.request_uri)
      request['Ocp-Apim-Subscription-Key'] = 'f28897cdf4944da9882e36b95508f910'
      request.body = ""
      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
      end
      items_hash = JSON.parse(response.body)
      emissions = (rand() * 10).round(2)
      items_hash['uk']['ghs']['products']['results'].each do |result|
        new_item = Item.new(name: result['name'], price: result['price'], quantity: result['ContentsQuantity'], retailer: 'Tesco', emission: emissions)
        new_item.generic_item = GenericItem.find_by(name: item)
        binding.pry
        new_item.save
      end
    end
    # Do something later
  end
end

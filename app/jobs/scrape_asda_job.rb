class ScrapeAsdaJob < ApplicationJob
  queue_as :default
  require 'open-uri'
  require 'nokogiri'
  require 'csv'

  def perform
    csv_text = File.read(Rails.root.join('db', 'generic_items.csv'))
    csv = CSV.parse(csv_text, :headers => true)
    data = []
    csv.each do |row|
      data << row.to_hash
    end
    data.each do |item|
      url = "https://www.ocado.com/search?entry=#{item[:name.to_s]}"
      # https://groceries.morrisons.com/search?entry=chcken%20breast
      html_file = open(url).read
      html_doc = Nokogiri::HTML(html_file)

      cards = html_doc.search('.fop-contentWrapper')
      counter = 0
      index = 0
      until counter == 3 do
        card = cards[index]
        name = card.search('h4.fop-title').children.first.text.strip
        weight = card.search('.fop-catch-weight').text.strip
        price = card.search('.fop-price').text.strip[1..-1]
        quantity = weight.scan(/\d+/)
        unit = weight.gsub(/\d+/, "")
        emissions = (rand() * 10).round(2)

        new_item = Item.new(
        generic_name: item[:name.to_s],
        generic_unit: item[:unit.to_s],
        generic_quantity: item[:quantity.to_s],
        category: item[:category.to_s],
        sub_category: item[:sub_category.to_s],
        image: item[:image.to_s],
        seasonal: item[:seasonal.to_s],
        name: name,
        price: price,
        quantity: quantity[0],
        retailer: 'Morrisons',
        emission: emissions
        )
        if new_item.save
          counter += 1
        end
        index += 1
      end
    end
# Do something later
  end
end

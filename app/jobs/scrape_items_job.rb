class ScrapeItemsJob < ApplicationJob
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
      url = "https://groceries.morrisons.com/search?entry=#{item[:name.to_s]}"
      # https://groceries.morrisons.com/search?entry=chcken%20breast
      html_file = open(url).read
      html_doc = Nokogiri::HTML(html_file)

      cards = html_doc.search('.fops-regular').children
      counter = 0
      index = 0
      begin
        until counter == 1 do
          card = cards[index]
          name = card.search('h4.fop-title').children.first.text.strip
          weight = card.search('.fop-catch-weight').text.strip
          if card.search('.fop-price').text.strip[0] == "£"
            price = card.search('.fop-price').text.strip[1..-1]
          else
            price = "0.#{card.search('.fop-price').text.strip[0..2]}".to_f
            # binding.pry
          end
          quantity = weight.scan(/[\d|.]+/)
          unit = weight.gsub(/[\d|.]+/, "")
          if unit.include? "kg" || "KG"
            unit = "kg"
          elsif unit.include? "g" || "G"
            unit = "g"
          end
          # emissions = (rand() * 100).round
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
          unit: unit,
          retailer: 'Morrisons',
          # emission: emissions
          )
          if new_item.quantity.nil? || new_item.quantity == "0"
            new_item.quantity = "1"
          end
          unless new_item.name.include? item[:name.to_s].split(" ")[0].capitalize
            new_item.name = nil
          end
          if new_item.unit.nil? || new_item.unit.include?(" per pack") || new_item.unit == ""
            new_item.unit = new_item.generic_unit
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
          if new_item.save
            counter += 1
          end
          index += 1
        end
      rescue
        next
      end
    end
# Do something later
  end
end

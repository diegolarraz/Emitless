require 'csv'

filepath = './generic_items.csv'
csv_options = {headers: :first_row}

# CSV.foreach(filepath, csv_options) do |row|
#   GenericItem.create(name: row['name'], category: row['category'], sub_category: row['sub_category'])
# end

require 'csv'

csv_text = File.read(Rails.root.join('db', 'generic_items.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  GenericItem.create!(image: row['image'], name: row['name'], category: row['category'], sub_category: row['sub_category'])
end

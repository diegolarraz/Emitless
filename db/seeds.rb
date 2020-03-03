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
  split_name = row['name'].split
  new_names = split_name.map { |word| word.capitalize }
  capitalize_name = new_names.join(" ")
  GenericItem.create!(image: row['image'], name: capitalize_name, category: row['category'], sub_category: row['sub_category'], unit: row['unit'], quantity: row['quantity'])
end

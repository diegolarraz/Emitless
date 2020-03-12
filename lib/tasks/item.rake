namespace :item do
  desc "Updating all items in Database"
  task update_all: :environment do
    puts "Deleting existing items"
    Item.destroy_all
    puts "Items deleted"
    sleep(1)
    puts "Seeding new items from Tesco."
    ApiItemsJob.perform_now
    puts "150 items created for Tesco."
    sleep(1)
    puts "Seeding new items from Morrisons"
    ScrapeItemsJob.perform_now
    puts "150 items created for Morrisons."
    sleep(1)

  end

  task update: :environment do
    puts "seed beginning"
    Item.destroy_all
    ApiItemsJob.perform_later
    ScrapeItemsJob.perform_later
    puts "seed complete"
    puts "#{Item.count} items created"
  end
end

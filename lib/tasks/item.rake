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
    puts "Seeding new items from Ocado"
    ScrapeAsdaJob.perform_now
    puts "150 items created for Ocado."
    sleep(1)
    puts "450 items added to database"
  end

end

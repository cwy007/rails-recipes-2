namespace :dev do

  task :fake => :environment do
    User.delete_all
    Event.delete_all
    Category.delete_all

    users = []
    users << User.create!( :email => "chanweiyan007@gmail.com", :password => "12345678" )

    10.times do |i|
      users << User.create!( :email => Faker::Internet.email, :password => "12345678")
      puts "Generate User #{i}"
    end

    20.times do |i|
      topic = Event.create!( :name => Faker::Cat.name,
                             :description => Faker::Lorem.paragraph,
                             :user_id => users.sample.id )
      puts "Generate Event #{i}"
    end

    Event.find_each do |e|
      5.times { |i| Ticket.create!(:name => "No #{i}" + Faker::Cat.name,
                                  :description => Faker::Lorem.paragraph,
                                  :price => Faker::Number.between(1000, 2000),
                                  :event_id => e.id)}
      puts "Generate 5 tickets for #{e.name}"
    end

    5.times do |i|
      Category.create!(:name => "No#{i} category")
    end
    puts "Generate 5 categories"
  end

end

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
  

  task :fake_event_and_registrations => :environment do
    event = Event.create!( :status => "public", :name => "全栈营 Meetup", :friendly_id => "fullstack-meetup")
    t1 = event.tickets.create!( :name => "Guest", :price => 0 )
    t2 = event.tickets.create!( :name => "VIP 第一期", :price => 199 )
    t3 = event.tickets.create!( :name => "VIP 第二期", :price => 199 )

    1000.times do |i|
      event.registrations.create!( :status => ["pending", "confirmed"].sample,
                                   :ticket => [t1, t2, t3].sample,
                                   :name => Faker::Cat.name, :email => Faker::Internet.email,
                                   :cellphone => "12345678", :bio => Faker::Lorem.paragraph,
                                   :created_at => Time.now - rand(10).days - rand(24).hours
                                     )
    end

    puts "Let's visit http://localhost:3000/admin/events/fullstack-meetup/registrations"

  end

end

start_count = 1
finish_count = 2

  30.times do |n|
      name = "Seeded Event"
      description = ""
      start = Time.now + start_count.day
      finish = Time.now + finish_count.day
      city_id = 1
      event = Event.create!(name: name, description: description, start: start,
                   finish: finish, city_id: city_id)
      LeadershipRole.create(leadable: event)
      start_count += 1
      finish_count += 2
    end



  City.create(:name => 'Portland, OR')
  City.create(:name => 'San Francisco, CA')
  City.create(:name => 'Seattle, WA')



  User.create(:first_name => 'Janice', :last_name => 'Levenhagen-Seeley', :email => 'janice.levenhagen@chicktech.org', :password => 'chicktech', :password_confirmation => 'chicktech', :phone => '9712700519', :role => 'superadmin', :city_id => 1 )
  User.create(:first_name => 'Admin', :last_name => 'Example', :email => 'admin@chicktech.org', :password => 'gurlsrule', :password_confirmation => 'gurlsrule', :phone => '5555555555', :role => 'admin', :city_id => 2 )
  User.create(:first_name => 'Hermione', :last_name => 'Granger', :email => 'hermione@hogwarts.edu', :password => 'voldemort', :password_confirmation => 'voldemort', :phone => '1435325454', :role => 'volunteer', :city_id => 1 )


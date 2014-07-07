City.create(:name => 'Portland, OR')
City.create(:name => 'San Francisco, CA')
City.create(:name => 'Seattle, WA')

User.create(:first_name => 'Super', :last_name => 'Admin', :email => 'super.admin@example.com', :password => 'superadmin', :password_confirmation => 'superadmin', :phone => '1111111111', :role => 'superadmin', :city_id => 1 )
User.create(:first_name => 'Normal', :last_name => 'Admin', :email => 'normal.admin@example.com', :password => 'normaladmin', :password_confirmation => 'normaladmin', :phone => '2222222222', :role => 'admin', :city_id => 2 )
User.create(:first_name => 'Normal', :last_name => 'Volunteer', :email => 'normal.volunteer@example.com', :password => 'normalvolunteer', :password_confirmation => 'normalvolunteer', :phone => '3333333333', :role => 'volunteer', :city_id => 1 )

30.times do |n|
  city = City.first(:offset => rand(City.count))
  name = "Seeded #{city.name} Event"
  description = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.\n\n Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.\n\n Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
  start = Time.now + (n + 1).day
  finish = start + 3.hour
  event = Event.create!(name: name, description: description, start: start, finish: finish, city_id: city.id)
  team_names = %w(Logistics Catering Marketing Volunteers)
  job_names = %w(Venue Food Advertizing Contacting Organizing Strategize)
  job_description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sapien mauris, volutpat ut viverra eu, vestibulum sit amet felis. Morbi at semper magna, in vehicula lorem. Nunc pretium sed elit ullamcorper auctor. Nunc vehicula bibendum ante a lacinia. Nunc malesuada semper sapien, eget imperdiet erat placerat ut. Phasellus luctus arcu."
  rand(team_names.count).times do |n|
    team = event.teams.create!(name: team_names[n])
    rand(job_names.count).times do |i|
      team.jobs.create!(name: job_names[i], description: job_description)
    end
  end
  rand(job_names.count).times do |n|
    event.jobs.create!(name: job_names[n], description: job_description)
  end
end

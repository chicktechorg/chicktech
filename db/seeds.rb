User.create(:first_name => 'Janice', :last_name => 'Levenhagen-Seeley', :email => 'janice.levenhagen@chicktech.org', :password => 'chicktech', :password_confirmation => 'chicktech', :phone => '9712700519', :role => 'superadmin')
User.create(:first_name => 'Admin', :last_name => 'Example', :email => 'admin@chicktech.org', :password => 'gurlsrule', :password_confirmation => 'gurlsrule', :phone => '5555555555', :role => 'admin')
User.create(:first_name => 'Hermione', :last_name => 'Granger', :email => 'hermione@hogwarts.edu', :password => 'voldemort', :password_confirmation => 'voldemort', :phone => '1435325454', :role => 'volunteer')

City.create(:name => 'Portland, OR')
City.create(:name => 'San Francisco, CA')
City.create(:name => 'Seattle, WA')

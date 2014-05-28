City.create(:name => 'Portland, OR')
City.create(:name => 'San Francisco, CA')
City.create(:name => 'Seattle, WA')

User.create(:first_name => 'Janice', :last_name => 'Levenhagen-Seeley', :email => 'janice.levenhagen@chicktech.org', :password => 'chicktech', :password_confirmation => 'chicktech', :phone => '9712700519', :role => 'superadmin', :city_id => 1 )
User.create(:first_name => 'Admin', :last_name => 'Example', :email => 'admin@chicktech.org', :password => 'gurlsrule', :password_confirmation => 'gurlsrule', :phone => '5555555555', :role => 'admin', :city_id => 2 )
User.create(:first_name => 'Hermione', :last_name => 'Granger', :email => 'hermione@hogwarts.edu', :password => 'voldemort', :password_confirmation => 'voldemort', :phone => '1435325454', :role => 'volunteer', :city_id => 1 )



Event.create(:name => "Clean the Park", :description => "", :start => "", :finish => "", :city_id => 1 )

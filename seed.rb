require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'faker'




1000.times do
	sql = "INSERT INTO soccer_teams (name, country, num_league_trophies) VALUES ('#{Faker::Company.name.gsub("'", "") + ' FC'}', '#{Faker::Address.country.gsub("'", "")}', #{rand(1..15)});"
	conn = PG.connect(:dbname => 'wdi', :host => 'localhost')
	conn.exec(sql)
	conn.close
end

1000.times do
	sql2 = "INSERT INTO soccer_players (name, age, current_team, nationality, past_teams) VALUES ('#{Faker::Name.name.gsub("'", "")}', #{rand(16..40)}, '#{Faker::Company.name.gsub("'", "") + ' FC'}', '#{Faker::Address.country.gsub("'", "")}', '#{Faker::Company.name.gsub("'", "") + ' FC'}');"
	conn = PG.connect(:dbname => 'wdi', :host => 'localhost')
	conn.exec(sql2)
	conn.close
end
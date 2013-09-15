# Include Necessary Gems ###
require 'sinatra'
require 'active_support/all'
require 'active_record'
require 'pg'
require 'digest/sha2'

# Enable the use of sessions
enable :sessions

### Establish ActiveRecord Connection to DB ###
ActiveRecord::Base.establish_connection(ENV['HEROKU_POSTGRESQL_WHITE_URL'] || 'postgres://localhost/dogs_and_toys')

### Output ActiveRecord SQL Statements to Terminal ###
ActiveRecord::Base.logger = Logger.new(STDOUT)

### Require Classes ###
require_relative './models/soccer_player.rb'
require_relative './models/soccer_team.rb'
require_relative './models/user.rb'

### Gives Access to All Teams on All Pages ###
before do 
	# SELECT * FROM soccer_teams;
	@nav_teams = SoccerTeam.order("name").all
end

### Non-Admin User Catch ###
before '*/edit' do
	if $user == nil
		redirect '/login'
	end
end

before '*/new' do
	if $user == nil
		redirect '/login'
	end
end

### Root Page ###
get '/' do
	erb :home
end

### Login Page ###
get '/login' do
	erb :login
end

post '/login' do
  username = params[:username]
  password =  Digest::SHA2.hexdigest(params[:password])

  if user = User.find(:first, :conditions => {:username => username, :password => password})
    session[:user] = username
    $user = session[:user]
    redirect '/'
  else
    erb :login
  end
end

### Logout Page ###
get '/logout' do
	session[:user] = nil
	$user = nil
	redirect '/'
end



### Displays Soccer Teams ###
get '/teams' do
	erb :home
end

### Add A New Soccer Team ###
get '/teams/new' do
	erb :new
end

### Filter Through Post Results to Create A New Team ###
post '/teams/new' do
	# INSERT INTO soccer_teams (params) VALUES (params[:team]);
	soccer_team = SoccerTeam.new(params[:team])
	soccer_team.save
	redirect '/'
end

### View Specific Soccer Team with Players ###
get '/teams/:team_id' do
	# SELECT * FROM soccer_teams WHERE id=params[:team_id];
	@team = SoccerTeam.find(params[:team_id])
	erb :one_team
end

### Create New Player for A Team ###
get '/teams/:team_id/new_player' do 
	@team_id = params[:team_id]
	erb :new_player
end

### Post New Player to Team ###
post '/teams/:team_id/new_player' do
	# SELECT * FROM soccer_teams WHERE id=params[:team_id];
	soccer_team = SoccerTeam.find(params[:team_id])
	team_id = params[:team_id].to_i
	# INSERT INTO soccer_players (params) VALUES (params[:player]);
	soccer_player = soccer_team.soccer_players.new(params[:player])
	soccer_player.save

	soccer_team.soccer_players << soccer_player
	redirect "/teams/#{team_id}"
end

### Edit Team Data ###
get '/teams/:team_id/edit' do
	team_id = params[:team_id]
	@team = SoccerTeam.find(team_id)

	erb :edit
end

post '/teams/:team_id/edit' do
  team_id = params[:team_id]
  name = params[:name]
  country = params[:country]
  # SELECT
  @team = SoccerTeam.find(team_id)

  # UPDATE
  @team.name = name
  @team.country = country

  @team.save

  redirect "/teams/#{team_id}"
end


### Delete Team from Database ###
get '/teams/:team_id/delete' do
	team_id = params[:team_id]
	@team = SoccerTeam.find(team_id)
	@team.soccer_players.each do |row|
		row.delete
	end
	# DELETE FROM soccer_teams WHERE id = params[:team_id];
	SoccerTeam.delete(team_id)
	redirect '/'
end

### View Specific Soccer Player ###
get '/teams/:team_id/:player_id' do
	@team_id = params[:team_id]
	team = SoccerTeam.find(@team_id)
	@player = team.soccer_players.find(params[:player_id])

	erb :one_player
end

### Edit Specific Soccer Player ###
get '/teams/:team_id/:player_id/edit' do
	@team_id = params[:team_id]
	@player_id = params[:player_id]

	team = SoccerTeam.find(@team_id)
	@player = team.soccer_players.find(@player_id)

	erb :edit_player
end

### Post for Edit Specific Soccer Player ###
post '/teams/:team_id/:player_id/edit' do
	team_id = params[:team_id]
	player_id = params[:player_id]

	team = SoccerTeam.find(team_id)
	player = team.soccer_players.find(player_id)

	player.name = params[:name]
	player.age = params[:age]
	player.nationality = params[:nationality]
	player.save

	redirect "/teams/#{team_id}/#{player_id}"
end


### Delete Specific Soccer Player ###
get '/teams/:team_id/:player_id/delete' do
	team_id = params[:team_id]
	player_id = params[:player_id]

	team = SoccerTeam.find(team_id)
	player = team.soccer_players.find(player_id)
	player.delete

	redirect "/teams/#{team_id}"
end







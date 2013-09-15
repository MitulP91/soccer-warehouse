class SoccerTeam < ActiveRecord::Base
	has_many :soccer_players
end
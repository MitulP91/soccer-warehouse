# SELECT LIST
sql1 = "SELECT * FROM soccer_teams;"
sql2 = "SELECT * FROM soccer_players;"

# SELECT ONE
sql3 = "SELECT name FROM soccer_teams;"
sql4 = "SELECT name FROM soccer_players;"

#INSERTING UPDATING
sql5 = "UPDATE soccer_teams SET num_league_trophies = 0 WHERE name = 'Arsenal FC';"
sql6 = "UPDATE soccer_players SET current_team = 'Chelsea FC' WHERE age < 30;"

#DELETING
sql7 = "DELETE FROM soccer_teams WHERE name = 'Arsenal FC';"
sql8 = "DELETE FROM soccer_players WHERE current_team = 'Arsenal FC';"
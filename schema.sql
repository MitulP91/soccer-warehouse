CREATE TABLE soccer_teams (
	id serial primary key,
	name varchar(100) NOT NULL UNIQUE,
	country varchar(100) NOT NULL
);

CREATE TABLE soccer_players (
	id serial primary key,
	name varchar(100) NOT NULL,
	age integer NOT NULL,
	nationality varchar(100) NOT NULL,
	soccer_team_id serial,
	FOREIGN KEY (soccer_team_id) REFERENCES soccer_teams(id)
);

CREATE TABLE users (
	id serial primary key,
	username varchar(100) NOT NULL UNIQUE,
	password varchar(64) NOT NULL
);
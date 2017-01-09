-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.



--create the database
DROP DATABASE tournament;
CREATE DATABASE tournament;

--connect to database
\c tournament

--create the tournament table
CREATE TABLE tournament (
  tournament_id SERIAL PRIMARY KEY, tournament_name TEXT
);

-- create the players table
CREATE TABLE players (
  player_id SERIAL PRIMARY KEY, player_name TEXT
);

--create tournament register
CREATE TABLE tournament_register (
  register_id SERIAL PRIMARY KEY,
  tournament_id INTEGER NOT NULL REFERENCES tournament(tournament_id)
);

--create the matches table
CREATE TABLE matches (
  match_id SERIAL PRIMARY KEY,
  --tournament_id INTEGER NOT NULL REFERENCES tournament(tournament_id),
  winner INTEGER references players(player_id) ON DELETE CASCADE, 
  loser INTEGER references players(player_id) ON DELETE CASCADE,
  matches INTEGER NOT NULL DEFAULT 0
);

-- VIEW TO DETERMINE WINS

CREATE VIEW player_wins AS
    SELECT players.player_id, count(matches.winner) AS wins
    FROM players LEFT JOIN matches 
    ON players.player_id = matches.winner
    GROUP by players.player_id
    ORDER by players.player_id;


-- VIEW TO DETERMINE THE NUMBER OF MATCHES

CREATE VIEW total_matches AS
	SELECT players.player_id, count(matches.winner) AS matches
	FROM players LEFT JOIN matches
	ON players.player_id = matches.winner
	OR players.player_id = matches.loser
	GROUP BY players.player_id
	ORDER by players.player_id;


-- VIEW THAT ADDS THE NUMBER OF WINS AND THE NUMBER OF MATCHES 
-- IN ONE TABLE

CREATE VIEW wins_matches AS
	SELECT total_matches.player_id, player_wins.wins, total_matches.matches
	FROM player_wins LEFT JOIN total_matches
	ON player_wins.player_id = total_matches.player_id;


-- VIEW USED TO DETERMINE PLAYERS' STANDINGS

CREATE VIEW players_standings AS 
	SELECT players.player_id, players.player_name, wins_matches.wins, wins_matches.matches
	FROM players LEFT JOIN wins_matches
	on players.player_id = wins_matches.player_id;

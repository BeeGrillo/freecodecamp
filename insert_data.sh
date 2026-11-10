#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

insert_into_teams ( ) {
  #asks for two teams and insert both
  $PSQL "INSERT INTO teams(name) VALUES ('$1');"
  WINNER_ID=$($PSQL "SELECT team_id from teams WHERE name = '$1';")
  
  $PSQL "INSERT INTO teams(name) VALUES ('$2');"
  OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name = '$2';")
  
}

insert_into_games ( ) {
  # args: year round winner_id opponent_id winner_goals opponent_goals
  $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
  VALUES ($1, '$2', $3, $4, $5, $6 )"
}


# Here starts file reading and insert calls
SKIP_HEADER=0
echo -e "\n-------------------------\n|STARTING DATA MIGRATION|\n-------------------------\n"
WINNER_ID=0
OPPONENT_ID=0
while IFS=, read -r year round winner opponent winner_goals opponent_goals
do
  if [ $SKIP_HEADER -eq 0 ] 
  then
    SKIP_HEADER=1
  else
    insert_into_teams "$winner" "$opponent"
    insert_into_games $year "$round" $WINNER_ID $OPPONENT_ID $winner_goals $opponent_goals
  fi
done < games.csv


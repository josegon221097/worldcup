#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    # get major_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $INSERT_WINNER_TEAM == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $WINNER
        fi
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    
  fi

  if [[ $OPPONENT != "opponent" ]]
  then
    # get major_id
    LOSER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  
  
    if [[ -z $LOSER_ID ]]
    then
      INSERT_LOSING_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $INSERT_LOSING_TEAM == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $WINNER
        fi
      LOSER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
  fi

  INSERT_GAMES_INFO=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND','$WINNER_ID','$LOSER_ID','$WINNER_GOALS','$OPPONENT_GOALS')")
  if [[ $INSERT_GAMES_INFO == "INSERT 0 1" ]]
  then
          echo Inserted game data
  fi
done
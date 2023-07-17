#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# clear tables
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  # exclude title row
  if [[ $YEAR -ne 'year' ]]
  then
    # INSERT TEAMS

    # get winner
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if not found
    if [[ -z $winner_id ]]
    then
      insert_winner=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $insert_winner == 'INSERT 0 1' ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi

    # get opponent
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $opponent_id ]]
    then
      insert_opponent=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $insert_opponent == 'INSERT 0 1' ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi

    # INSERT GAMES

    # get ids
    if [[ -z $winner_id ]]
    then
      winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    if [[ -z $opponent_id ]]
    then
      opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    # insert game
    insert_game=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $winner_id, $opponent_id, $W_GOALS, $O_GOALS)")
    if [[ $insert_game == 'INSERT 0 1' ]]
    then
      echo Inserted new game.
    fi

  fi

done



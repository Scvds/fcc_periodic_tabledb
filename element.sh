#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."

else
  # check if number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # get element from input
    ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")

  # check if symbol
  else
  LENGTH=$(echo -n "$1" | wc -m)
    if [[ $LENGTH -lt 3 ]]
    then
      # get element
      ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1'")

    # assume it's a name
    else
      ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1'")
    fi
  fi
  # check if element has been found in database
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  
  else
    ELEMENT=$(echo $ELEMENT | sed 's/|/ /g')
    # echo $ELEMENT
    # get all variables from element and print!
    echo $ELEMENT | while read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi

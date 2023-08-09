#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ARG=$1
 
MAIN_MENU() {

if [[ -z $ARG ]]
 then
   echo "Please provide an element as an argument."
   else 
    # find element by atomic number
    if [[ $ARG =~ [0-9] ]]
    then
    ATOMIC_N=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$ARG'")
    else
        if [[ $ARG =~ ^[A-Za-z]{1,2}$ ]]
    then
     ATOMIC_N=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$ARG'")
     else 
     if [[ $ARG =~ ^[A-Z][a-z]{3,}$ ]]
    then
     ATOMIC_N=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$ARG'")
     else
     echo "I could not find that element in the database."
   fi
  fi
 fi
 if [[ $ATOMIC_N ]]
 then
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_N")
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_N")
  TYPE=$($PSQL "SELECT type FROM types FULL JOIN properties USING (type_id) WHERE atomic_number = $ATOMIC_N")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_N")
  M_P=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_N")
  B_P=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_N")
 echo "The element with atomic number $ATOMIC_N is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $M_P celsius and a boiling point of $B_P celsius."
 fi
fi
}

MAIN_MENU

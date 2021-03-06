#!/bin/bash
bundle install

# check if savefile exists.
# if savefile exists puts welcome back and request the owners name and password
# if savefule does not exist greet the user and prompt them to setup the first manager on their account
# run the program with first time arguments

clear
echo $1 "< - Initialising Pos - >"


function savefile_exist? {
    FILE=./saves/savefile.json
    if test -f "$FILE"; then
        ruby index.rb
    else
        echo $1 "Hello and welcome to your cafe POS"
        echo $1 "We are now going to set up your first manager profile"
        echo -e "Please enter your Name: "
        read name
        echo -e "Please enter your Password: "
        read password
        ruby index.rb $name $password  
    fi
}
savefile_exist?
#!/bin/bash

# init vars
myMIN='0'
myMAX='256'

size_SWAP=$(free -h | grep Swap | awk '$1 {print $2}')

# Ask for input, force an integer between 1 and 512
inputValue() {
myINPUT='-1'
until [[ "$myINPUT" -ge "$myMIN" && "$myINPUT" -le "$myMAX" ]]
    do
        echo "$1 (Min: $myMIN Max: $myMAX): "
        
        read myINPUT
    done


}

inputValue "Enter the amount of GB to add to the current swap partition" 
echo "The swap partition will be expanded $myINPUT GB above its current size"


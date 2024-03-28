#!/bin/bash

# Array storing the card suits and ranks
card_suits=("♠" "♥" "♦" "♣")
card_ranks=("A" "2" "3" "4" "5" "6" "7" "8" "9" "10" "J" "Q" "K")

# Function to display ASCII representation of a card
function display_card() {
    local suit=$1
    local rank=$2

    if [[ $rank != "10" ]]; then
        rank=" $rank"
    fi

    echo "┌─────────┐"
    echo "│$rank       │"
    echo "│         │"
    echo "│    $suit    │"
    echo "│         │"
    echo "│      $rank │"
    echo "└─────────┘"
}

# Function to randomly select a card from the deck
function draw_card() {
    local suit=${card_suits[$((RANDOM % 4))]}
    local rank=${card_ranks[$((RANDOM % 13))]}
    display_card "$suit" "$rank"
}

# Draw a card from the deck and display the result
draw_card

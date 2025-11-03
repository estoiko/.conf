#!/bin/bash

# Set the directory path
DIRECTORY="/Users/eliseystoyko/Documents/estoiko/"

# Change to the specified directory
cd "$DIRECTORY" || exit

# Check if a.cpp exists and delete it
if [ -f "a.cpp" ]; then
    rm "a.cpp"
    
fi

# Create a new empty a.cpp file
touch "a.cpp"
code .
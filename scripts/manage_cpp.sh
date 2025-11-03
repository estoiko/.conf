#!/bin/bash

# Set the directory path
DIRECTORY=$(PWD)

# Change to the specified directory
cd "$DIRECTORY" || exit

# Check if a.cpp exists and delete it
if [ -f "a.cpp" ]; then
    rm "a.cpp"
fi

# Create a new empty a.cpp file
touch "a.cpp"
code .

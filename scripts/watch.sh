#!/bin/bash

# Function to handle file changes
handle_change() {
    while read -r directory events filename; do
        if [[ "$filename" =~ .*\.tex$ ]]; then
            echo $filename
            make main || VERBOSE=true make main || true
        fi
    done
}

# Watch the current directory and its subdirectories for changes
inotifywait -m -r -e modify . | handle_change


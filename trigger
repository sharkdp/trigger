#!/bin/bash
#
# Usage:
#
#   trigger COMMAND FILE1 [FILE2...]
#
# Runs the given COMMAND every time one of the FILEs is changed.
#
# In the COMMAND string, #1, #2, ..., #9 can be used as synonyms for FILE1,
# FILE2, ..., FILE9.
#
# Example:
#
#   trigger 'python #1' main.py config.py
#


# Check command line arguments
if [[ $# -lt 2 ]]; then
    echo "Usage: trigger COMMAND FILE1 [FILE2...]"
    exit 1
fi

# Output colors
reset='\x1b[0m'
blue='\x1b[34;01m'
green='\x1b[32;01m'
red='\x1b[31;01m'

# Replace occurences of #1, #2, .., #9 in the given command with the
# corresponding file names
command="$1"
shift
for n in {1..9}; do
    # get the n-th filename
    ARG="${!n}"

    # replace #n with the n-th filename
    command="${command//\#${n}/$ARG}"
done

run() {
    # Run the command and measure the elapsed time
    local starttime=$SECONDS

    eval "$command"
    local status="$?"

    local elapsed=$((SECONDS - starttime))

    # Status output
    local status_info=""
    local color="$green"

    if [[ $status -ne 0 ]]; then
        status_info="with exit status $status "
        color=$red
    fi

    echo -e "${color}>>>${reset} finished ${status_info}after ${elapsed} second(s)"
    echo
}

# Run the command once
echo -e "${blue}>>>${reset} Initial run of '${command}'"
run

# Run the command repeatedly everytime one of the files changes
while cfile=$(inotifywait --quiet --format '%w' --event close_write "$@"); do
    echo -e "$blue>>>$reset File '$cfile' has been changed"
    run
done

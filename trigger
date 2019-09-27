#!/bin/bash
#
# Usage:
#
#   trigger [OPTIONS] COMMAND [FILE...]
#
# Runs the given COMMAND every time one of the FILEs is changed.
#
# In the COMMAND string, #1, #2, ..., #9 can be used as synonyms for FILE1,
# FILE2, ..., FILE9.
#
# OPTIONS
#
#   -i, --interrupt
#          If this mode is enabled, a running COMMAND will be killed if a file
#          changes.
#
# EXAMPLE
#
#   trigger 'python #1' main.py config.py
#

# This flag determines Whether or not 'trigger' is running in interrupt mode.
# If this mode is enabled, trigger will kill the subprocess when a file changes
# (in case it is still running).
interruptMode=false

# Check command line arguments
if [[ "$1" == "-i" || "$1" == "--interrupt" ]]; then
    interruptMode=true

    # The process ID of the subprocess
    lastPID="none"
    shift
fi

if [[ $# -eq 0 ]]; then
    echo "Usage: trigger COMMAND [FILE...]"
    exit 1
fi

# Output colors
reset='\x1b[0m'
blue='\x1b[34;01m'
green='\x1b[32;01m'
red='\x1b[31;01m'

command="$1"

if [[ $# -gt 1 ]]; then
    # Replace occurences of #1, #2, .., #9 in the given command with the
    # corresponding file names

    shift
    for n in {1..9}; do
        # get the n-th filename
        ARG="${!n}"

        # replace #n with the n-th filename
        command="${command//\#${n}/$ARG}"
    done

    watchall=false
else
    watchall=true
fi

runChild() {
    if [[ $# -eq 1 ]]; then
        local cfile="$1"
        echo -e "${blue}>>>${reset} File '$cfile' has been changed"
    fi

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

run() {
    if [[ $interruptMode = true ]]; then
        numPIDS=$(ps --no-headers -o pid --ppid=$$ | wc -w)
        if [[ $numPIDS != 1 ]]; then
            # We have at least one subprocess (that will be killed)
            echo -e "${red}>>>${reset} Interrupting currently running process\n"

            kill $lastPID
            wait $lastPID 2> /dev/null
        fi

        # Start the subprocess asynchronously
        runChild "$@" &
        lastPID=$!
    else
        # Start the subprocess synchronously
        runChild "$@"
    fi
}

# Run the command once
echo -e "${blue}>>>${reset} Initial run of '${command}'"
run

# Run the command repeatedly, every time one of the files changes

if [[ $watchall = true ]]; then
    # Watch all files in the current directory

    while cfile=$(inotifywait --quiet --format '%w%f' --event close_write,move_self --exclude '\.git' -r .); do
        run "$cfile"
    done
else
    while cfile=$(inotifywait --quiet --format '%w' --event close_write,move_self "$@"); do
        [[ ! -e "$cfile" ]] && sleep 0.1
        if [[ ! -e "$cfile" ]]; then
            echo -n "File '$cfile' was deleted, waiting for it to reappear .."
            while [[ ! -e "$cfile" ]]; do
                sleep 0.1
                echo -n "."
            done
            echo
        fi
        run "$cfile"
    done
fi

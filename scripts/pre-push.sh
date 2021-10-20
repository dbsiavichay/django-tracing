#!/bin/bash

set +e

SOURCE=$(basename "${BASH_SOURCE[0]}")
SOURCE_DIR=$(dirname "${BASH_SOURCE[0]}")

source "$SOURCE_DIR/utils.sh"

BASE_BRANCH="origin/master"

# Check only changed files and fix them when it is possible
echo ""

MODIFIED_PY_FILES=$(git diff $BASE_BRANCH --name-only | grep -e ".py$" 2>&1)
if [[ $MODIFIED_PY_FILES != "" ]]; then
    echo $MODIFIED_PY_FILES | no_log_if_successful xargs flake8
    set +e
else
    printf "Running flake8 ... ${GREEN}Ignored!${RESET} (no *.py files with changes)\n"
fi

if [[ $MODIFIED_PY_FILES != "" ]]; then
    echo $MODIFIED_PY_FILES | no_log_if_successful xargs isort
    set +e
else
    printf "Running isort ... ${GREEN}Ignored!${RESET} (no *.py files with changes)\n"
fi


# Check all files and fix them when it is possible
no_log_if_successful black .

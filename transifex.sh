#!/usr/bin/env bash
#
# Push source files to Transifex.
#
# This script is called after every successful build on Travis CI.
# Only run on master
if [ $TRAVIS_BRANCH == master ]
then
    echo "Submitting translation files to Transifex"
    make messages
    pip install "transifex-client==0.10"
    # Write .transifexrc file
    sudo echo $'[https://www.transifex.com]\nhostname = https://www.transifex.com\nusername = '"$TRANSIFEX_USER"$'\npassword = '"$TRANSIFEX_PASSWORD"$'\ntoken = '"$TRANSIFEX_API_TOKEN"$'\n' > ~/.transifexrc
    tx push --source --translations --no-interactive
fi

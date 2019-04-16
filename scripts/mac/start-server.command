#!/bin/bash

echo -n -e "\033]0;Start Local Server\007"

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "../../${DIR}"

docker-compose up -d

osascript -e 'tell application "Terminal" to close (every window whose name contains "Start Local Server")' & exit
#!/bin/bash

echo -n -e "\033]0;Stop Local Server\007"

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "../../${DIR}"

docker-compose down -v

osascript -e 'tell application "Terminal" to close (every window whose name contains "Stop Local Server")' & exit
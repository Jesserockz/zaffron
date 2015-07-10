#!/bin/bash
cd /Users/touchtech/workspace/zaffron
git pull origin master
launchctl unload ~/Library/LaunchAgents/nz.co.touchtech.zaffron.plist
launchctl load ~/Library/LaunchAgents/nz.co.touchtech.zaffron.plist
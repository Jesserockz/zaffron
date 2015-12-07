#!/bin/bash
export PATH=/usr/local/bin:$PATH
cd /Users/touchtech/workspace/zaffron
git pull origin master
npm install
launchctl unload ~/Library/LaunchAgents/nz.co.touchtech.zaffron.plist
launchctl load ~/Library/LaunchAgents/nz.co.touchtech.zaffron.plist
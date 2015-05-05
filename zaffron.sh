#!/bin/bash

export HUBOT_HIPCHAT_JID=""
export HUBOT_HIPCHAT_PASSWORD=""
export HUBOT_HIPCHAT_NAME=""
export HUBOT_HIPCHAT_TOKEN=""

export HUBOT_ANSWER_TO_LIFE="IllegalQuestionException, no such answer exists"

bin/hubot --adapter hipchat

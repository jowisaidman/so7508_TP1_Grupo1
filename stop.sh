#!/bin/bash

ps -ef | grep ".*process.sh" | grep -v grep | awk '{print $2}' | xargs kill
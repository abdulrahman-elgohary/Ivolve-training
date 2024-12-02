#!/bin/bash
EMAIL=ahmedelgohary96@gmail.com
PASS=pvykhttqenucnslt

USAGE=$(df -h / | tail -1 | awk '{print $5}' | tr -d %)
THRESHOLD=10

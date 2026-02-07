#!/bin/bash

if pgrep -x "spotify" > /dev/null; then
    spicetify apply
else
    spicetify apply && pkill spotify
fi

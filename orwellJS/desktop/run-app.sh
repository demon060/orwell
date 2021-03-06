#!/bin/bash

# Copyright (C) 2016, Canonical Ltd.
# All rights reserved.

# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree. An additional grant
# of patent rights can be found in the PATENTS file in the same directory.

args=""
on_device=0
plugins_path=""
asset_path="share"
executor=""

react_host=`hostname -I`

# Parse args
for arg in "$@"
do
  IFS="=" read -a parts <<< "$arg"
  if [[ $parts == "--on-device" ]]; then
    on_device=1
  elif [[ $parts == "--plugins-path" ]]; then
    plugins_path=${parts[1]}
    args=$args" --plugins-path=./plugins"
  elif [[ $parts == "--asset-path" ]]; then
    asset_path=${parts[1]}
  elif [[ $parts == "--executor" ]]; then
    if [[ $on_device == 1 ]]; then
      # Force net executor for now
      executor="ReactNetExecutor"
    else
      executor=${parts[1]}
    fi
    args=$args" --executor=$executor"
  else
    args=$args" $parts"
  fi
done

# Handle defaults
if [[ -z "$executor" ]]; then
  if [[ $on_device == 1 ]]; then
    executor="ReactNetExecutor"
    args=$args" --executor=ReactNetExecutor"
  fi

  # The RN application selects pipe executor by default
fi

# For net case, try and run executor; it is probably OK if this fails - it's
# just running elsewhere
if [[ "$executor" == "ReactNetExecutor" ]]; then
  (node /home/lz/orwell/orwellJS/desktop/bin/ubuntu-server.js 2>&1 > /dev/null) &
fi

if [[ $on_device == 1 ]]; then
  app_path="/home/phablet/Orwell"

# Push binaries
  adb push /home/lz/orwell/orwellJS/desktop/bin/Orwell "$app_path/Orwell"
  [ -d "$plugins_path" ] && adb push "$plugins_path" "$app_path/plugins/"
  [ -d "$asset_path" ] && adb push "$asset_path" "$app_path/share/"
#  adb reverse --no-rebind tcp:8081 tcp:808

# Run app on device
  adb shell "cd $app_path && REACT_SERVER_HOST=$react_host ./Orwell --host $react_host $args -- --desktop_file_hint=/usr/share/applications/webbrowser-app.desktop"
else
# Run app locally
  /home/lz/orwell/orwellJS/desktop/bin/Orwell $args
fi


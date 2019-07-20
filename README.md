# Orwell Network Video Recorder

Orwell is meant to be a modern Network Video Recorder built on top of React Native with support for Windows, Android, iOS, macOS and Linux.

Orwell is intended to implement the video receiver and decoder in C++ so it is the same in all devices. Only the displaying of the video is specific for each device. In case of desktop, it's QT based, in Android it's Java based, and in iOS it's C++/Objective-C based. The user interface will be coded in react native so the same code will work on all devices, with the difference only being in the mobile/desktop layouts.

# What works rigth now?

There is a QT client in `qt` folder for testing purposes, and a desktop react native client (which is supposed to be the app we're building) in orwellJS which is almost working. Both examples should show the image of a Vstarcam camera for a few seconds. The qt and react native should work on linux, windows and mac, but I compiled only in linux for now. There is no code for iOS or Android yet, but I intend to do it someday. 

Can you help me? I'd be nice to have people working on different parts of the project.

# How to build

See the dockerfile in `docker` folder to understand how your system might look like for the installation to work, or follow below:

In Ubuntu, you should install these:

```
sudo apt update && sudo apt install -y cmake build-essential ca-certificates \
    libavcodec-dev libavformat-dev libavdevice-dev libavfilter-dev libavutil-dev libboost-dev libboost-thread-dev \
    libgl-dev perl python git wget unzip 
```

and also have a modern QT installtion on `/home/$USER`. Explained below.

## QT little app (debugging only)

This little app is used for debugging. It runs the QT module that is injected into React Native Desktop (which is based on QT).

#### If you have an updated QT installed on your machine (like Qt 5.11 or later)

For the little QT/QML visualizer (just for debugging):

```
cd qt
cmake .
make
./orwell
```
#### If you have locally installed cmake or want to point the locally installed QT directly:

If you don't have qt already, download here: https://www.qt.io/download-qt-installer

Download a modern cmake, the one that comes with ubuntu, for me, won't set `DCMAKE_PREFIX_PATH`: https://cmake.org/download/ (don't forget to `make install`)

So, if you want to pass QT folder manually (change QT folder to tour version):

```
cd qt
cmake -DCMAKE_PREFIX_PATH=/home/$USER/Qt/5.13.0/gcc_64 -DCMAKE_BUILD_TYPE=Debug .
make
./orwell
```

ps: you must have cameras accessible with the IPs and passwords of `qt/main.qml`.

Warning: it'll likely not work with your cameras for now, but it should work with vstarcam cameras

## React Native Desktop app

```
cd orwellJS
#1st shell
npm install #CURRENTLY NOT WORKING, will install buggy version, see below how to temporary fix it
npm start #starts bundler. 
#2nd shell
node node_modules/react-native/ubuntu-server.js #starts js server
#3rd shell
react-native run-desktop
```

ps: you must have cameras accessible with the IPs and passwords of `orwellJS/index.desktop.js` (or maybe other places for now)

To temporary fix the `npm install` problem, do this on a temporary folder:

```
npm install -g react-native-cli 
react-native init DesktopSampleApp --version status-im/react-native-desktop
cd DesktopSampleApp
react-native desktop
```

then coopy the contents of `node_modules` to orwellJS, this will make what `npm install` were supposed to do. This is currently an issue here: https://github.com/status-im/react-native-desktop/issues/457

Warning: it'll likely not work with your cameras for now, but it should work with vstarcam cameras

## React Native Android app

To be done.

## React Native iOS app

To be done.

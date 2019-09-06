#!/usr/bin/env bash

set -euo pipefail

wget https://www.intersense.com/wp-content/uploads/2018/12/InterSense_SDK_4.2381.zip
unzip InterSense_SDK_4.2381.zip

git clone https://github.com/AudioSceneDescriptionFormat/asdf-rust.git
cd asdf-rust
git submodule update --init
cargo cinstall --release --prefix=/usr/local --destdir=temp
sudo cp -r temp/usr/local/* /usr/local/
cd ..

if [ "$TRAVIS_OS_NAME" = osx ]
then
  git clone git://github.com/zaphoyd/websocketpp.git
  cd websocketpp
  # https://github.com/zaphoyd/websocketpp/issues/794
  git checkout develop
  mkdir build
  cd build
  cmake ..
  make
  sudo make install
  cd ..
  cd ..

  git clone git://github.com/hoene/libmysofa.git
  cd libmysofa
  cd build
  cmake -DCMAKE_BUILD_TYPE=Debug ..
  make
  sudo make install
  cd ..
  cd ..

  sudo cp SDK/MacOSX/Sample/*.h /usr/local/include
  sudo cp SDK/MacOSX/UniversalLib/libisense.dylib /usr/local/lib
fi

if [ "$TRAVIS_OS_NAME" = linux ]
then
  git clone https://github.com/vrpn/vrpn.git
  cd vrpn
  mkdir build
  cd build
  cmake -DVRPN_BUILD_JAVA=OFF ..
  make
  sudo make install
  cd ..
  cd ..

  # libfmt >= 5 is needed, which is in Ubuntu disco
  git clone https://github.com/fmtlib/fmt.git
  cd fmt
  mkdir build
  cd build
  cmake ..
  make
  sudo make install
  cd ..
  cd ..

  sudo cp SDK/Linux/Sample/*.h /usr/local/include
  sudo cp SDK/Linux/x86_64/libisense.so /usr/local/lib
  sudo ldconfig
fi

exit 0

#! /bin/bash
set -e

gitsrc=https://github.com/IOCoinNetwork/iocoin.git
repo_name=aurora
commit=e7de3f2086531983ecaca1708e723ee0c69d38bb

echo "**** Creating /ioc_src/ *****"
if [ -d "/ioc_src" ]; then rm -Rf /ioc_src; fi
mkdir /ioc_src
cp -R ./* /ioc_src/
cp ./makefile.android /ioc_src/makefile.android

cd /ioc_src
git clone $gitsrc iocoin
cd iocoin
git checkout $commit
patch -p1 < /ioc_src/e7de3f2-Android.patch
mv /ioc_src/makefile.android ./src/makefile.android
cd ..

./build.sh $repo_name i686-linux-android 32 
./build.sh $repo_name armv7a-linux-androideabi 32 
./build.sh $repo_name aarch64-linux-android 64 
./build.sh $repo_name x86_64-linux-android 64 

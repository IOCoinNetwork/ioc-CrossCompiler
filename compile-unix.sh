#! /bin/bash
set -e

gitsrc=https://github.com/IOCoinNetwork/iocoin.git
repo_name=aurora
commit=e7de3f2086531983ecaca1708e723ee0c69d38bb

# If fails, uncomment the target_host line and replace x86_64-pc-linux-gnu with the correct host target (try hardcoded)
TARGET_TYPE=pc-linux
LIBC=gnu
target_host=`(uname -m) 2>/dev/null`-$TARGET_TYPE-$LIBC || UNAME_MACHINE=SearchNameOnDependsFolder
#target_host=x86_64-pc-linux-gnu 

export HOST=${target_host}
export IOC_LIB_PATH=/ioc_src/depends/${target_host}/lib/
export IOC_INCLUDE_PATH=/ioc_src/depends/${target_host}/include/
export BOOST_LIB_SUFFIX=-mt

echo "**** Creating /ioc_src/ *****"
if [ -d "/ioc_src" ]; then rm -Rf /ioc_src; fi
mkdir /ioc_src
cp -R ./* /ioc_src/

cd /ioc_src
git clone $gitsrc iocoin
cd iocoin
git checkout $commit
mv /ioc_src/makefile.unix ./src/makefile.unix
cd ..

num_jobs=4
if [ -f /proc/cpuinfo ]; then
    num_jobs=$(grep ^processor /proc/cpuinfo | wc -l)
fi
cd depends
make -j $num_jobs
cd ../iocoin/src

echo ***********Building iocoind for ${target_host}
make -j $num_jobs -f makefile.unix USE_UPNP=-
tar -zcf /ioc_src/${target_host}_${repo_name}.tar.gz iocoind

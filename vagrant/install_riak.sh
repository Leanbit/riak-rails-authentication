#!/bin/bash
# Run as root, to become root in vagrant: sudo -H bash -l
apt-get update
apt-get install build-essential libncurses5-dev openssl libssl-dev fop xsltproc unixodbc-dev
wget http://erlang.org/download/otp_src_R15B01.tar.gz
tar zxvf otp_src_R15B01.tar.gz
cd otp_src_R15B01
./configure && make && sudo make install

cd ..
wget http://s3.amazonaws.com/downloads.basho.com/riak/1.4/1.4.8/riak-1.4.8.tar.gz
tar zxvf riak-1.4.8.tar.gz
cd riak-1.4.8
make devrel DEVNODES=5

# change in devX/etc/app.config bind ip address to 0.0.0.0 (do not use this conf in prod)
# change storage_backend to riak_kv_eleveldb_backend, that supports secondary index
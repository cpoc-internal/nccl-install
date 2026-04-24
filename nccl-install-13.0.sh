#!/bin/bash

echo "Downloading required libraries..."

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update

sudo apt install libnccl2=2.28.7-1+cuda13.0 libnccl-dev=2.28.7-1+cuda13.0 -y
sudo apt install build-essential devscripts debhelper fakeroot -y
sudo apt install openmpi-bin openmpi-common libopenmpi-dev -y
sudo apt install mpich -y
sudo modprobe nvidia-peermem

#make pkg.debian.build
#ls build/pkg/deb/

echo "back to root"
sleep 5

echo "cloning nccl test"
# git clone https://github.com/cpoc-internal/nccl-tests
# cd nccl-tests
# make -Wno-deprecated-gpu-targets
git clone https://github.com/NVIDIA/nccl-tests.git
cd nccl-tests
make CUDA_HOME=/usr/local/cuda-13.0
./build/all_reduce_perf -b 8 -e 10g -f 2 -g 4

echo "done"

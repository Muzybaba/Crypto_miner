#!/bin/bash

# Update Termux packages
pkg update -y && pkg upgrade -y

# Install dependencies
pkg install git build-essential cmake automake autoconf libtool -y
pkg install curl -y

# Install required miners
pkg install cpuminer opt -y  # For Bitcoin & Litecoin
pkg install openssl -y       # Required for cpuminer
pkg install nano -y          # Optional text editor
pkg install wget -y

# Clone XMRig for Monero mining
rm -rf xmrig
git clone https://github.com/xmrig/xmrig.git
cd xmrig

# Build XMRig
mkdir build && cd build
cmake ..
make -j$(nproc)
cd ../..

# User Input
echo "Choose a coin to mine:"
echo "1. Bitcoin (BTC)"
echo "2. Litecoin (LTC)"
echo "3. Monero (XMR)"
read -p "Enter choice [1-3]: " choice

# Configure mining details
case $choice in
    1)
        coin="Bitcoin"
        miner="cpuminer-opt"
        read -p "Enter your BTC wallet address: " wallet
        pool="stratum+tcp://stratum.slushpool.com:3333"
        ;;
    2)
        coin="Litecoin"
        miner="cpuminer-opt"
        read -p "Enter your LTC wallet address: " wallet
        pool="stratum+tcp://litecoinpool.org:3333"
        ;;
    3)
        coin="Monero"
        miner="./xmrig/build/xmrig"
        read -p "Enter your XMR wallet address: " wallet
        pool="stratum+tcp://pool.minexmr.com:4444"
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac

# Start mining
echo "Starting mining for $coin..."
if [ "$miner" == "cpuminer-opt" ]; then
    $miner -a sha256d -o $pool -u $wallet -p x
else
    $miner -o $pool -u $wallet -p x --coin=monero
fi
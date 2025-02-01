#!/bin/bash

# Update Termux packages
pkg update -y && pkg upgrade -y

# Install dependencies
pkg install git build-essential cmake automake autoconf libtool -y
pkg install curl -y

# Clone XMRig repository
git clone https://github.com/xmrig/xmrig.git
cd xmrig

# Build XMRig
mkdir build && cd build
cmake ..
make -j$(nproc)

# Function to start mining
start_mining() {
    coin=$1
    wallet=$2
    pool=$3

    echo "Starting mining for $coin..."
    ./xmrig -o $pool -u $wallet -p x --coin=$coin
}

# User Input
echo "Choose a coin to mine:"
echo "1. Bitcoin (BTC)"
echo "2. Litecoin (LTC)"
echo "3. Monero (XMR)"
read -p "Enter choice [1-3]: " choice

# Configure mining details
case $choice in
    1)
        coin="bitcoin"
        read -p "Enter your BTC wallet address: " wallet
        pool="stratum+tcp://pool.hashvault.pro:3333"
        ;;
    2)
        coin="litecoin"
        read -p "Enter your LTC wallet address: " wallet
        pool="stratum+tcp://litecoinpool.org:3333"
        ;;
    3)
        coin="monero"
        read -p "Enter your XMR wallet address: " wallet
        pool="stratum+tcp://pool.minexmr.com:4444"
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac

# Start mining
start_mining $coin $wallet $pool

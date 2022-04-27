#!/bin/bash
set -e

PIO_CONFIG_HOME=/home/ubuntu/config

echo "Downloading configuration..."
wget "https://raw.githubusercontent.com/provenance-io/$NETWORK/main/$CHAIN_ID/config.toml" -P $PIO_CONFIG_HOME
wget "https://raw.githubusercontent.com/provenance-io/$NETWORK/main/$CHAIN_ID/genesis.json" -P $PIO_CONFIG_HOME

sudo service supervisor stop

if [ "$NETWORK" = "mainnet" ]; then
	wget "https://github.com/provenance-io/provenance/releases/download/v1.0.1/provenance-linux-amd64-v1.0.1.zip" -P /tmp
	unzip /tmp/provenance-linux-amd64-v1.0.1.zip -d /tmp/provenance

	sudo sed -i "s/\ -t\ /\ /" /etc/supervisor/conf.d/provenanced.conf
else
	wget "https://github.com/provenance-io/provenance/releases/download/v0.2.1/provenance-linux-amd64-v0.2.1.zip" -P /tmp
	unzip /tmp/provenance-linux-amd64-v0.2.1.zip -d /tmp/provenance
fi

mv /tmp/provenance/bin cosmovisor/genesis/

echo -e "\nexport LD_LIBRARY_PATH=\"/home/ubuntu/cosmovisor/current/bin:/usr/local/lib\"\n" >> ~/.bashrc
source ~/.bashrc

echo "Config setup completed!"

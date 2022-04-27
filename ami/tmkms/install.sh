#!/bin/bash
set -e

CARGO_PATH=/home/ec2-user/.cargo
CARGO_BIN=${CARGO_PATH}/bin

sudo yum -y update
sudo yum -y install gcc git
sudo amazon-linux-extras install aws-nitro-enclaves-cli
sudo yum install aws-nitro-enclaves-cli-devel -y
sudo yum install -y openssl-devel

echo "Configuring docker..."
sudo usermod -aG ne ec2-user
sudo usermod -aG docker ec2-user
newgrp docker
sudo systemctl enable docker
sudo systemctl enable nitro-enclaves-allocator.service
sudo systemctl start docker

echo "Downloading and installing rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo "Downloading and installing tmkms tools..."
git clone https://github.com/crypto-com/tmkms-light.git

echo "Building tmkms tools..."
cd tmkms-light
sudo docker build -t aws-ne-build \
       --build-arg USER=$(whoami) \
       --build-arg USER_ID=$(id -u) \
       --build-arg GROUP_ID=$(id -g) \
       --build-arg RUST_TOOLCHAIN="1.56.1" \
       --build-arg CTR_HOME="$CTR_HOME" \
       -f Dockerfile.nitro .
$CARGO_BIN/cargo build --target x86_64-unknown-linux-gnu -p tmkms-nitro-helper --release
sudo cp target/x86_64-unknown-linux-gnu/release/tmkms-nitro-helper /usr/local/bin/
cd ..
mkdir /home/ec2-user/.tmkms

# echo "Configuring tmkms service..."
sudo mv /tmp/run.sh /home/ec2-user/run.sh
sudo chown ec2-user:ec2-user /home/ec2-user/run.sh
chmod a+x run.sh
sudo mv /tmp/tmkms.service /lib/systemd/system/tmkms.service
sudo systemctl daemon-reload
sudo systemctl enable tmkms.service
sudo systemctl stop tmkms

sudo systemctl stop docker

echo "Installation completed!"

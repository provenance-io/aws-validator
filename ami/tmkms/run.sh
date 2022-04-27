#!/bin/bash
set -e

TRAP_FUNC ()
{
  echo "Stopping ..."
  tmkms-nitro-helper enclave stop || echo "enclave is not running!"
  sudo kill -TERM $(pidof vsock-proxy) || echo "vsock-proxy is not running!"
  sudo kill -TERM $(pidof tmkms-nitro-helper) || echo "tmkms-nitro-helper is not running!"
  exit 1
}

tmkms-nitro-helper enclave stop || echo "enclave is not running!"

vsock-proxy 8000 kms.<AWS_REGION>.amazonaws.com 443 &
echo "[kms vsock-proxy] Running in background ..."
vsock-proxy 5000 <PROVENANCE_NODE_PRIVATE_DNS> 26669 &
echo "[validator vsock-proxy] Running in background ..."

trap TRAP_FUNC TERM SIGTERM INT SIGINT KILL SIGKILL EXIT

sleep 1

tmkms-nitro-helper launch-all -v

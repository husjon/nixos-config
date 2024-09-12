#! /usr/bin/env bash

set -e

cd "$(dirname $(realpath $0))"
cd ../keys/hosts

REMOTE_USER=root
REMOTE_HOST=$1

case $REMOTE_HOST in
    localhost)
        REMOTE_KEY=$(sudo cat /etc/ssh/ssh_host_rsa_key)
        REMOTE_HOST=$(hostname)
        ;;
    *)
        REMOTE_KEY=$(ssh ${REMOTE_USER}@${REMOTE_HOST} "cat /etc/ssh/ssh_host_rsa_key")
        ;;
esac


echo "$REMOTE_KEY" | nix-shell -p 'import (fetchTarball "https://github.com/Mic92/ssh-to-pgp/archive/refs/tags/1.1.2.tar.gz") {}' \
    --run "ssh-to-pgp -name ${REMOTE_USER} -email ${REMOTE_USER}@${REMOTE_HOST} -o ${REMOTE_HOST}.asc"

# Adding key to existing secret
# sops --rotate \
#     --in-place \
#     --add-pgp ${PGP-FINGERPRINT} \
#     hosts/servers/cache.husjon.xyz/secrets.yaml

#!/usr/bin/env bash

set -eEuo pipefail

# Install k3s
curl -sfL https://get.k3s.io \
| sh -s - --disable=servicelb --disable=traefik

# Download Flux
VERSION="2.2.2"
if [! -f "/usr/local/flux2/${VERSION}/flux" ]
then
    sudo mkdir -p /usr/local/flux2/${VERSION}

    curl --silent --location https://github.com/fluxcd/flux2/releases/download/v${VERSION}/flux_${VERSION}_linux_amd64.tar.gz \
    | sudo tar --directory /usr/local/flux2/${VERSION} -xvzf - \
    && sudo ln -sf /usr/local/flux2/${VERSION}/flux /usr/local/bin/flux \
    && flux version
fi

# Install Flux
source .env
flux bootstrap github \
  --token-auth \
  --owner='testruction' \
  --repository='fleet-infra-public' \
  --branch='main' \
  --components-extra='image-reflector-controller,image-automation-controller' \
  --path='clusters/local/development/k3s'
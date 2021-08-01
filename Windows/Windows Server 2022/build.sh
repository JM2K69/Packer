#!/bin/bash -x

echo "Building Windows Server 2019 GUI ..."

echo "Applying packer build to BaseWindowsServer.json ..."
packer build  -var-file=WindowsServer2022_gui.json BaseWindowsServer.json


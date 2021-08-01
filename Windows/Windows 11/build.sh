#!/bin/bash -x

echo "Building Windows 11 ..."

echo "Applying packer build to Windows11.json ..."
packer build  -var-file=Windows11.json BaseWindows11.json.pkr.hcl


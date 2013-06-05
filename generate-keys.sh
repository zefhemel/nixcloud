#!/bin/sh

mkdir -p keys
ssh-keygen -t rsa -N "" -f keys/serverkey

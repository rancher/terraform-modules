#!/usr/bin/env bash
set -x

docker run -d --restart=unless-stopped -p 8080:8080 --name=rancher-server rancher/server:stable
